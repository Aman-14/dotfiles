return {
	{
		"yetone/avante.nvim",
		event = "InsertEnter",
		version = false, -- set this if you want to always pull the latest change

		opts = {
			providers = {
				claude = {
					api_key_name = "cmd:cat /Users/aman/.asta/anthropic.personal",
				},
				copilot_gpt41 = {
					__inherited_from = "copilot",
					model = "gpt-4.1",
				},
				copilot_sonnet37 = {
					__inherited_from = "copilot",
					model = "claude-3.7-sonnet",
				},
				copilot_gemini25 = {
					__inherited_from = "copilot",
					model = "gemini-2.5-pro",
				},
				gemini = {
					api_key_name = "cmd:cat /Users/aman/.asta/aistudio.google",
					model = "gemini-2.5-pro-preview-03-25",
				},
				openai = {
					endpoint = "https://openrouter.ai/api/v1",
					api_key_name = "cmd:cat /Users/aman/.asta/openrouter",
					model = "openai/gpt-4.1",
				},
				["openrouter-sonnet-3.5"] = {
					endpoint = "https://openrouter.ai/api/v1",
					__inherited_from = "openai",
					api_key_name = "cmd:cat /Users/aman/.asta/openrouter",
					model = "anthropic/claude-3.5-sonnet",
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
				["openrouter-gemini-2.5-pro"] = {
					endpoint = "https://openrouter.ai/api/v1",
					__inherited_from = "openai",
					api_key_name = "cmd:cat /Users/aman/.asta/openrouter",
					model = "google/gemini-2.5-pro-preview-03-25",
				},
				groq = {
					__inherited_from = "openai",
					api_key_name = "cmd:cat /Users/aman/.asta/groq",
					endpoint = "https://api.groq.com/openai/v1/",
					model = "llama-3.3-70b-versatile",
				},
			},
			provider = "copilot_sonnet37",
			cursor_applying_provider = "groq",
			behaviour = {
				enable_cursor_planning_mode = true,
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
			"zbirenbaum/copilot.lua",
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
