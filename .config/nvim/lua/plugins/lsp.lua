return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		{ "williamboman/mason.nvim", config = true },
		"williamboman/mason-lspconfig.nvim",
		{ "j-hui/fidget.nvim", opts = {} },
		{ "hrsh7th/cmp-nvim-lsp" },
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
		})
		require("lspconfig.ui.windows").default_options.border = "single"

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

		local mason_lspconfig = require("mason-lspconfig")

		mason_lspconfig.setup_handlers({
			function(server_name)
				local server_settings = require("plugins.lsp.servers")[server_name]

				if server_settings == nil then
					return
				end

				local root_dir = server_settings.root_dir
				server_settings.root_dir = nil

				require("lspconfig")[server_name].setup({
					capabilities = capabilities,
					on_attach = require("plugins.lsp.on_attach").on_attach,
					settings = server_settings,
					filetypes = server_settings.filetypes,
					root_dir = root_dir,
					on_init = function(client)
						if client.name == "pyright" then
							print("Python path: " .. client.config.settings.python.pythonPath)
						end
					end,
				})
			end,
		})

		vim.diagnostic.config({
			title = false,
			underline = true,
			virtual_text = true,
			signs = true,
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

		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		-- add borders in hover windows
		vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
			border = "rounded",
		})
	end,
}
