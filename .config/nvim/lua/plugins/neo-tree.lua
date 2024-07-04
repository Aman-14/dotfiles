return {
	"nvim-neo-tree/neo-tree.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	event = "VeryLazy",
	keys = {
		{ "<leader>e", ":Neotree toggle float reveal<CR>", silent = true, desc = "Float File Explorer" },
		{ "<leader><tab>", ":Neotree toggle left reveal<CR>", silent = true, desc = "Left File Explorer" },
	},
	config = function()
		require("neo-tree").setup({
			close_if_last_window = true,
			popup_border_style = "single",
			enable_git_status = true,
			enable_modified_markers = true,
			enable_diagnostics = true,
			sort_case_insensitive = true,
			default_component_configs = {
				indent = {
					with_markers = true,
					with_expanders = true,
				},
				modified = {
					symbol = " ",
					highlight = "NeoTreeModified",
				},
				icon = {
					folder_closed = " ",
					folder_open = " ",
					folder_empty = " ",
					folder_empty_open = " ",
				},
				git_status = {
					symbols = {
						-- Change type
						added = "",
						deleted = "",
						modified = "",
						renamed = "",
						-- Status type
						untracked = "",
						ignored = "",
						unstaged = "",
						staged = "",
						conflict = "",
					},
				},
			},
			window = {
				position = "float",
				width = 35,
				mappings = {
					["c"] = "copy_to_clipboard",
					["m"] = "cut_to_clipboard",
					["C"] = function(state)
						-- get the current node
						local node = state.tree:get_node()
						local path = node and node.path or state.path
						vim.fn.setreg("+", path)
						print("Copied: " .. path)
					end,
					["P"] = function(state)
						local node = state.tree:get_node()
						while node and node.type ~= "directory" do
							local parent_id = node:get_parent_id()
							if parent_id == nil then
								-- we must have reached the root node
								-- this should not happen because the root node is always a directory
								-- but just in case...
								node = nil
								break
							end
							node = state.tree:get_node(parent_id)
						end
						-- if we somehow didn't find a directory, just use the root node
						local destinationPath = node and node.path or state.path
						local srcPath = vim.fn.getreg("+")
						local cmd = string.format('cp -r "%s" "%s"', srcPath, destinationPath)
						local result = os.execute(cmd)
						if result == 0 then
							print("Copied from '" .. srcPath .. "' to '" .. destinationPath .. "'")
						else
							print("Failed to copy from '" .. srcPath .. "' to '" .. destinationPath .. "'")
						end
					end,
				},
			},
			filesystem = {
				use_libuv_file_watcher = true,
				filtered_items = {
					hide_dotfiles = false,
					hide_gitignored = false,
				},
				follow_current_file = {
					enabled = true,
				},
			},
			event_handlers = {
				{
					event = "neo_tree_window_after_open",
					handler = function(args)
						if args.position == "left" or args.position == "right" then
							vim.cmd("wincmd =")
						end
					end,
				},
				{
					event = "neo_tree_window_after_close",
					handler = function(args)
						if args.position == "left" or args.position == "right" then
							vim.cmd("wincmd =")
						end
					end,
				},
			},
		})
	end,
}
