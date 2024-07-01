return {
	-- comments
	{
		"numToStr/Comment.nvim",
		opts = {},
		lazy = false,
	},
	-- Neovim notifications and LSP progress messages
	{
		"j-hui/fidget.nvim",
		enabled = true,
		tags = "1.2.0",
		config = function()
			require("fidget").setup({})
		end,
	},
	-- Add/change/delete surrounding delimiter pairs with ease
	{
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup()
		end,
	},
	-- Neovim setup for init.lua and plugin development with full signature help, docs and completion for the nvim lua API
	{
		"folke/neodev.nvim",
		config = function()
			require("neodev").setup({
				library = { plugins = { "neotest" }, types = true },
			})
		end,
	},
	-- Simple winbar/statusline plugin that shows your current code context
	{
		"SmiteshP/nvim-navic",
		config = function()
			local icons = require("config.icons")
			require("nvim-navic").setup({
				highlight = true,
				lsp = {
					auto_attach = true,
					preference = { "typescript-tools" },
				},
				click = true,
				separator = " " .. icons.ui.ChevronRight .. " ",
				depth_limit = 0,
				depth_limit_indicator = "..",
				icons = {
					File = " ",
					Module = " ",
					Namespace = " ",
					Package = " ",
					Class = " ",
					Method = " ",
					Property = " ",
					Field = " ",
					Constructor = " ",
					Enum = " ",
					Interface = " ",
					Function = " ",
					Variable = " ",
					Constant = " ",
					String = " ",
					Number = " ",
					Boolean = " ",
					Array = " ",
					Object = " ",
					Key = " ",
					Null = " ",
					EnumMember = " ",
					Struct = " ",
					Event = " ",
					Operator = " ",
					TypeParameter = " ",
				},
			})
		end,
	},
	-- works with nvim-navic
	{
		"LunarVim/breadcrumbs.nvim",
		config = function()
			require("breadcrumbs").setup()
		end,
	},
	{
		"ThePrimeagen/refactoring.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-treesitter/nvim-treesitter" },
		},
		config = function()
			require("refactoring").setup({})
		end,
	},
	-- tmux & split window navigation
	"christoomey/vim-tmux-navigator",

	-- maximizes and restores current window
	"szw/vim-maximizer",
	"mbbill/undotree",

	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("harpoon").setup()
		end,
	},
	-- autopairs for neovim written by lua
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},
	-- auto close html tags
	{
		"windwp/nvim-ts-autotag",
		event = "BufRead",
		opts = {},
		dependencies = {
			{ "nvim-treesitter/nvim-treesitter" },
		},
	},
	-- markdown preview
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},
	-- find and replace
	{
		"nvim-pack/nvim-spectre",
		config = function()
			require("spectre").setup()
		end,
	},
	{
		"Exafunction/codeium.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
		},
		config = function()
			require("codeium").setup({})
		end,
	},
	"sindrets/diffview.nvim",
}
