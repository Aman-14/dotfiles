return {
	{
		"yetone/avante.nvim",
		event = "InsertEnter",
		version = false, -- set this if you want to always pull the latest change

		opts = {
			provider = "claude",
			claude = {
				api_key_name = "cmd:cat /Users/aman/.asta/anthropic.personal", -- the shell command must prefixed with `^cmd:(.*)`
			},
			gemini = {
				api_key_name = "cmd:cat /Users/aman/.asta/aistudio.google",
				model = "gemini-2.0-flash",
			},
			vendors = {
				openrouter = {
					endpoint = "https://openrouter.ai/api/v1",
					__inherited_from = "openai",
					api_key_name = "cmd:cat /Users/aman/.asta/openrouter",
					model = "qwen/qwen-2.5-coder-32b-instruct",
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
