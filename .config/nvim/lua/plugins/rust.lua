return {
	{
		"mrcjkb/rustaceanvim",
		ft = { "rust" },
		version = "^4",
		config = function()
			vim.g.rustaceanvim = {
				server = {
					on_attach = require("plugins.lsp.on_attach").on_attach,
				},
			}
		end,
	},
	-- crates
	{
		"saecki/crates.nvim",
		tag = "stable",
		ft = { "rust", "toml" },
		event = { "BufRead", "BufReadPre", "BufNewFile" },
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("crates").setup({
				popup = {
					border = "rounded",
				},
			})
		end,
	},
}
