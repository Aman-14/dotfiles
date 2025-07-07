return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		{ "williamboman/mason.nvim", config = true },
		"mason-org/mason-lspconfig.nvim",
		{ "j-hui/fidget.nvim",       opts = {} },
		"saghen/blink.cmp",
		"b0o/schemastore.nvim",
	},
	config = function()
		require("mason").setup({
			ui = {
				border = "rounded",
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})
		require("mason-lspconfig").setup({
			ensure_installed = vim.tbl_keys(require("plugins.lsp.servers")),
			automatic_enable = false
		})
		require("lspconfig.ui.windows").default_options.border = "single"

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

		local servers = require("plugins.lsp.servers")

		for name, config in pairs(servers) do
			require("lspconfig")[name].setup({
				capabilities = capabilities,
				on_attach = require("plugins.lsp.on_attach").on_attach,
				settings = config.settings,
				filetypes = config.filetypes,
				root_dir = config.root_dir,
			})
		end

		vim.diagnostic.config({
			title = false,
			underline = true,
			virtual_text = {
				source = false, -- We will handle the source display manually
				spacing = 2,
				prefix = "", -- Use a character to see if it replaces the block
				format = function(diagnostic)
					local source = (diagnostic.source or "")
					if source ~= "" then
						source = source .. ": "
					end

					local icons = {
						[vim.diagnostic.severity.ERROR] = " ",
						[vim.diagnostic.severity.WARN] = " ",
						[vim.diagnostic.severity.HINT] = "󰠠 ",
						[vim.diagnostic.severity.INFO] = " ",
					}
					local icon = icons[diagnostic.severity] or ""
					return icon .. source .. diagnostic.message
				end,
			},
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "",
					[vim.diagnostic.severity.WARN] = "",
					[vim.diagnostic.severity.HINT] = "󰠠",
					[vim.diagnostic.severity.INFO] = "",
				},
			},
			update_in_insert = false,
			severity_sort = true,
			float = {
				source = "always",
				style = "minimal",
				border = "rounded",
				header = "",
				prefix = "",
			},
		})

		-- add borders in hover windows
		vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
			border = "rounded",
		})

		vim.lsp.handlers["workspace/diagnostic/refresh"] = function(_, _, ctx)
			local ns = vim.lsp.diagnostic.get_namespace(ctx.client_id)
			pcall(vim.diagnostic.reset, ns)
			return true
		end
	end,
}
