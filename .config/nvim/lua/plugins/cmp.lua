return {
	{
		"saghen/blink.cmp",
		enabled = false,
		-- optional: provides snippets for the snippet source
		dependencies = {
			"rafamadriz/friendly-snippets",
			"onsails/lspkind.nvim",
		},

		-- use a release tag to download pre-built binaries
		version = "*",
		-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source using latest nightly rust with:
		-- build = 'nix run .#build-plugin',

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			completion = {
				menu = {
					auto_show = function(ctx)
						-- Menu is auto shown only when searching
						return ctx.mode ~= "cmdline" or vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype())
					end,
					-- draw = {
					-- 	components = {
					-- 		kind_icon = {
					-- 			ellipsis = false,
					-- 			text = function(ctx)
					-- 				print("ctx.kind", ctx.kind)
					-- 				return require("lspkind").symbolic(ctx.kind, {
					-- 					mode = "symbol",
					-- 				})
					-- 			end,
					-- 		},
					-- 	},
					-- },
				},
				accept = {
					auto_brackets = {
						enabled = true,
						kind_resolution = {
							enabled = true,
							blocked_filetypes = { "typescriptreact", "javascriptreact", "vue" },
						},
					},
				},
			},
			-- 'default' for mappings similar to built-in completion
			-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
			-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
			-- See the full "keymap" documentation for information on defining your own keymap.
			keymap = {
				preset = "none", -- disable default preset to use our custom mappings
				["<C-k>"] = { "select_prev", "fallback" },
				["<C-j>"] = { "select_next", "fallback" },
				["<Up>"] = { "select_prev", "fallback" },
				["<Down>"] = { "select_next", "fallback" },
				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },
				["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-e>"] = { "hide", "fallback" },
				["<C-h>"] = { "show_signature", "hide_signature", "fallback" },
				["<CR>"] = {
					function(cmp)
						return cmp.accept({ behavior = "replace" })
					end,
					"fallback",
				},
			},

			appearance = {
				-- Sets the fallback highlight groups to nvim-cmp's highlight groups
				-- Useful for when your theme doesn't support blink.cmp
				-- Will be removed in a future release
				use_nvim_cmp_as_default = true,
				-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
				kind_icons = {
					Text = "",
					Method = "",
					Function = "",
					Constructor = "",
					Field = "",
					Variable = "",
					Class = "",
					Interface = "",
					Module = "",
					Property = "",
					Unit = "",
					Value = "",
					Enum = "",
					Keyword = "",
					Snippet = "",
					Color = "",
					File = "",
					Reference = "",
					Folder = "",
					EnumMember = "",
					Constant = "",
					Struct = "",
					Event = "",
					Operator = "",
					TypeParameter = "",
				},
			},

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { "lsp", "path", "snippets", "buffer", "lazydev" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						-- make lazydev completions top priority (see `:h blink.cmp`)
						score_offset = 100,
					},
				},
			},
		},
		opts_extend = { "sources.default" },
	},
	{
		-- Autocompletion
		"hrsh7th/nvim-cmp",
		enabled = true,
		lazy = true,
		-- event = "BufRead",
		dependencies = {
			-- Snippet Engine & its associated nvim-cmp source
			-- "L3MON4D3/LuaSnip",
			-- "saadparwaiz1/cmp_luasnip",

			-- Adds LSP completion capabilities
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",

			-- Adds a number of user-friendly snippets
			-- "rafamadriz/friendly-snippets",

			-- Adds vscode-like pictograms
			"onsails/lspkind.nvim",
		},
		config = function()
			local cmp = require("cmp")
			-- local luasnip = require("luasnip")

			-- require("luasnip.loaders.from_vscode").lazy_load()
			-- luasnip.config.setup({})

			cmp.setup({
				-- snippet = {
				-- 	expand = function(args)
				-- 		luasnip.lsp_expand(args.body)
				-- 	end,
				-- },
				completion = {
					completeopt = "menu,menuone,noinsert",
				},
				mapping = cmp.mapping.preset.insert({
					["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
					["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
					["<C-e>"] = cmp.mapping.abort(), -- close completion window
					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					}),
				}),
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				sources = {
					{ name = "lazydev", group_index = 0 },
					{ name = "nvim_lsp" },
					{ name = "nvim_lua" },
					-- { name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
					{ name = "calc" },
					{ name = "emoji" },
					{ name = "treesitter" },
					{ name = "crates" },
					{ name = "tmux" },
				},
			})
		end,
	},
}
