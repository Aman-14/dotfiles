return {
	{
		"nvimtools/none-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"jay-babu/mason-null-ls.nvim",
			"nvim-lua/plenary.nvim",
		},
		config = function()
			local mason_null_ls = require("mason-null-ls")
			local null_ls = require("null-ls")

			local null_ls_utils = require("null-ls.utils")

			mason_null_ls.setup({
				ensure_installed = {
					"prettier", -- prettier formatter
					"stylua", -- lua formatter
					"eslint_d", -- js linter
					-- "golangci_lint", -- go linter
					"shellcheck", -- shell linter
					"yamllint", -- yaml linter
					"buf", -- buf formatter
					"beautysh", -- shell formatter
					"yamlfmt", -- yaml formatter
					"spell", -- spell checker
					"black", -- python formatter
				},
			})

			local formatting = null_ls.builtins.formatting
			local diagnostics = null_ls.builtins.diagnostics
			local code_actions = null_ls.builtins.code_actions

			local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

			null_ls.setup({
				root_dir = null_ls_utils.root_pattern(".null-ls-root", "Makefile", ".git", "package.json"),

				sources = {
					formatting.stylua,
					formatting.prettier,
					-- formatting.gofumpt,
					formatting.buf,
					formatting.beautysh,
					formatting.yamlfmt,
					formatting.black,
					formatting.forge_fmt,
					formatting.rustfmt.with({
						extra_args = { "--edition=2021" },
					}),

					-- diagnostics.eslint_d,
					diagnostics.eslint_d.with({ -- js/ts linter
						condition = function(utils)
							return utils.root_has_file({ ".eslintrc.js", ".eslintrc.cjs" }) -- only enable if root has .eslintrc.js or .eslintrc.cjs
						end,
					}),
					code_actions.eslint_d,
					diagnostics.shellcheck,
					diagnostics.yamllint.with({
						extra_args = { "-d {extends: relaxed, rules: {line-length: {max: 120}}}" },
					}),
					code_actions.gitsigns,
					code_actions.refactoring,
				},
				-- configure format on save
				on_attach = function(current_client, bufnr)
					if current_client.supports_method("textDocument/formatting") then
						vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = augroup,
							buffer = bufnr,
							callback = function()
								vim.lsp.buf.format({
									filter = function(client)
										--  only use null-ls for formatting instead of lsp server
										return client.name == "null-ls"
									end,
									bufnr = bufnr,
								})
							end,
						})
					end
				end,
			})
		end,
	},
}
