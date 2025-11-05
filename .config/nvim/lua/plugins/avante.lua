return {
	{
		"yetone/avante.nvim",
		event = "InsertEnter",
		version = false, -- set this if you want to always pull the latest change
		enabled = true,
		config = function()
			local asta = os.getenv("ASTA_DIR")
			if asta then
				local k = vim.secure.read(asta .. "/openai")
				if k then
					vim.env.AVANTE_OPENAI_API_KEY = k
				end
			end
			require("avante").setup({
				provider = "openai",
				providers = {
					openai = {
						endpoint = "https://api.openai.com/v1",
						model = "gpt-4.1",
						timeout = 30000,
						extra_request_body = {
							temperature = 0.75,
							max_tokens = 4096,
						},
					},
				},
				behaviour = {
					auto_suggestions = false, -- Experimental stage
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
			})
		end,
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
