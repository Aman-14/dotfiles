return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		{ "williamboman/mason.nvim", config = true },
		"mason-org/mason-lspconfig.nvim",
		{ "j-hui/fidget.nvim", opts = {} },
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
		local mason_ensure = vim.tbl_filter(function(name)
			local config = require("plugins.lsp.servers")[name]
			return config == nil or config.mason ~= false
		end, vim.tbl_keys(require("plugins.lsp.servers")))

		require("mason-lspconfig").setup({
			ensure_installed = mason_ensure,
			automatic_enable = false,
		})
		require("lspconfig.ui.windows").default_options.border = "single"

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

		local servers = require("plugins.lsp.servers")
		local on_attach = require("plugins.lsp.on_attach").on_attach
		local handlers = {
			["workspace/diagnostic/refresh"] = function(_, _, ctx)
				local ns = vim.lsp.diagnostic.get_namespace(ctx.client_id)
				pcall(vim.diagnostic.reset, ns)
				return true
			end,
		}

		vim.lsp.config("*", {
			handlers = handlers,
		})

		for name, config in pairs(servers) do
			local server_config = vim.tbl_deep_extend("force", {}, config or {})
			server_config.mason = nil
			local merged_config = vim.tbl_deep_extend("force", {
				capabilities = capabilities,
				on_attach = on_attach,
			}, server_config)
			vim.lsp.config(name, merged_config)
			vim.lsp.enable(name)
		end

		local diagnostic_config = {
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
		}

		local ok, err = pcall(vim.diagnostic.config, diagnostic_config)
		if not ok then
			if not tostring(err):match("Invalid buffer id") then
				error(err)
			end

			-- Recover from stale diagnostics tied to deleted scratch/plugin buffers.
			for ns, _ in pairs(vim.diagnostic.get_namespaces()) do
				pcall(vim.diagnostic.reset, ns)
			end
			pcall(vim.diagnostic.config, diagnostic_config)
		end
	end,
}
