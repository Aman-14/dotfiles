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
		event = "BufReadPost", -- Lazy load after buffer is read
		config = function()
			-- Patch breadcrumbs to not set winbar on floating windows
			local breadcrumbs = require("breadcrumbs")
			local original_get_winbar = breadcrumbs.get_winbar
			breadcrumbs.get_winbar = function()
				-- Skip floating windows
				if vim.api.nvim_win_get_config(0).relative ~= "" then
					return
				end
				return original_get_winbar()
			end
			breadcrumbs.setup()
		end,
	},
	-- tmux & split window navigation
	"christoomey/vim-tmux-navigator",
	-- maximizes and restores current window
	"szw/vim-maximizer",
	{
		"mbbill/undotree",
		cmd = "UndotreeToggle",
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
		event = "InsertEnter",
		config = function()
			require("spectre").setup()
		end,
	},
	{ "sindrets/diffview.nvim" },
	-- better inputs
	{
		"stevearc/dressing.nvim",
		event = "VeryLazy",
	},
	-- Markdown preview
	{
		-- Make sure to set this up properly if you have lazy=true
		"MeanderingProgrammer/render-markdown.nvim",
		opts = {
			file_types = { "markdown", "Avante" },
		},
		ft = { "markdown", "Avante" },
	},
	-- copilot like suggestions
	-- {
	-- 	"supermaven-inc/supermaven-nvim",
	-- 	event = "InsertEnter",
	-- 	config = function()
	-- 		require("supermaven-nvim").setup({})
	-- 	end,
	-- },
	-- {
	-- 	"zbirenbaum/copilot.lua",
	-- 	event = "InsertEnter",
	-- 	config = function()
	-- 		require("copilot").setup()
	-- 	end,
	-- },
	{
		"stevearc/oil.nvim",
		opts = {},
		-- Optional dependencies
		dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
		cmd = { "Oil" }, -- Load on Oil command
	},
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"dmtrKovalenko/fff.nvim",
		build = function()
			-- this will download prebuild binary or try to use existing rustup toolchain to build from source
			-- (if you are using lazy you can use gb for rebuilding a plugin if needed)
			require("fff.download").download_or_build_binary()
		end,
		opts = { -- (optional)
			debug = {
				enabled = true, -- we expect your collaboration at least during the beta
				show_scores = true, -- to help us optimize the scoring system, feel free to share your scores!
			},
		},
		lazy = false,
	},
}
