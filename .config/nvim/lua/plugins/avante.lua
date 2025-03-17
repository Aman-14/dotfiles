return {
	{
		"yetone/avante.nvim",
		event = "InsertEnter",
		version = false, -- set this if you want to always pull the latest change

		opts = {
			provider = "openrouter-sonnet-3.5",
			claude = {
				api_key_name = "cmd:cat /Users/aman/.asta/anthropic.personal", -- the shell command must prefixed with `^cmd:(.*)`
			},
			gemini = {
				api_key_name = "cmd:cat /Users/aman/.asta/aistudio.google",
				model = "gemini-2.0-flash",
			},
			vendors = {
				["openrouter-sonnet-3.5"] = {
					endpoint = "https://openrouter.ai/api/v1",
					__inherited_from = "openai",
					api_key_name = "cmd:cat /Users/aman/.asta/openrouter",
					-- model = "anthropic/claude-3.7-sonnet:beta",
					model = "anthropic/claude-3.5-sonnet",
					-- model = "openai/chatgpt-4o-latest",
				},
				["openrouter-sonnet-3.7"] = {
					endpoint = "https://openrouter.ai/api/v1",
					__inherited_from = "openai",
					api_key_name = "cmd:cat /Users/aman/.asta/openrouter",
					model = "anthropic/claude-3.7-sonnet:beta",
				},
				["openrouter-o3-mini"] = {
					endpoint = "https://openrouter.ai/api/v1",
					__inherited_from = "openai",
					api_key_name = "cmd:cat /Users/aman/.asta/openrouter",
					model = "openai/o3-mini",
				},
			},
			web_search_engine = {
				provider = "google",
			},
			file_selector = {
				provider = "telescope",
				provider_opts = {
					layout_config = {
						width = 0.4, -- 40%
						height = 0.4,
					},
				},
			},
		},

		-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
		build = "make",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- The below dependencies are optional,
			"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
			{
				-- support for image pasting
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					-- recommended settings
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
						-- required for Windows users
						use_absolute_path = true,
					},
				},
			},
		},
	},
}
