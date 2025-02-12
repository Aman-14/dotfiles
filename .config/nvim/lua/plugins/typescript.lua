return {
	"pmizio/typescript-tools.nvim",
	event = "BufReadPre",
	dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	opts = {},
	config = function()
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		require("typescript-tools").setup({
			on_attach = function()
				require("plugins.lsp.on_attach").on_attach()
				vim.keymap.set("n", "<leader>oi", ":TSToolsOrganizeImports<CR>")
				vim.keymap.set("n", "<leader>ru", ":TSToolsRemoveUnusedImports<CR>")
				vim.keymap.set("n", "<leader>rf", ":TSToolsRenameFile<CR>")
				vim.keymap.set("n", "<leader>ia", ":TSToolsAddMissingImports<CR>")
			end,
			capabilities = require("blink.cmp").get_lsp_capabilities(capabilities),
			settings = {
				separate_diagnostic_server = true,
				expose_as_code_action = "all",
				-- tsserver_plugins = {},
				tsserver_max_memory = "auto",
				complete_function_calls = true,
				include_completions_with_insert_text = true,
				tsserver_file_preferences = {
					includeInlayParameterNameHints = "all", -- "none" | "literals" | "all";
					includeInlayParameterNameHintsWhenArgumentMatchesName = true,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = true,
					includeInlayVariableTypeHintsWhenTypeMatchesName = true,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = true,
					includeInlayEnumMemberValueHints = true,
					includeCompletionsForModuleExports = true,
					quotePreference = "auto",
				},
			},
		})
	end,
}
