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
					"yamllint", -- yaml linter
					"buf", -- buf formatter
					"shfmt", -- shell formatter
					-- "yamlfmt", -- yaml formatter
					"spell", -- spell checker
					"gofmt", -- golang formatter
					"xmllint",
					"biome",
				},
			})

			local formatting = null_ls.builtins.formatting
			local diagnostics = null_ls.builtins.diagnostics
			local code_actions = null_ls.builtins.code_actions

			local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

			null_ls.setup({
				root_dir = function(fname)
					return null_ls_utils.root_pattern("biome.json")(fname)
						or null_ls_utils.root_pattern(".null-ls-root", "Makefile", ".git", "package.json")(fname)
				end,
				debug = false,

				sources = {
					formatting.stylua,
					formatting.prettier.with({
						condition = function(utils)
							return not utils.root_has_file({ "biome.json" })
						end,
						extra_args = { "--ignore-path", "none" },
					}),
					formatting.buf,
					formatting.shfmt,
					-- formatting.yamlfmt,
					formatting.biome.with({
						condition = function(utils)
							return utils.root_has_file({ "biome.json" })
						end,
					}),
					-- formatting.forge_fmt,
					formatting.gofmt,
					formatting.xmllint,
					diagnostics.yamllint.with({
						extra_args = { "-d {extends: relaxed, rules: {line-length: {max: 200}}}" },
					}),
					code_actions.gitsigns,
					code_actions.refactoring,
				},
				-- configure format on save
				on_attach = function(current_client, bufnr)
					-- if current_client.supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({
								filter = function(client)
									-- if null-ls supports formatting then use null-ls else use lsp server
									if current_client.supports_method("textDocument/formatting") then
										return client.name == "null-ls"
									end
									return true
								end,
								bufnr = bufnr,
							})
						end,
					})
					-- end
				end,
			})
		end,
	},
}
