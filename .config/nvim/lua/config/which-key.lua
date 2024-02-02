return {
	defaults = {
		mode = { "n", "v" },
		[";"] = { ":Alpha<CR>", "Dashboard" },
		w = { ":w!<CR>", "Save" },
		h = { ":nohlsearch<CR>", "No Highlight" },
		p = { require("telescope.builtin").lsp_document_symbols, "Document Symbols" },
		-- P = { require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace Symbols" },
		f = { "<cmd>Telescope find_files<cr>", "Find Files (Root)" },
		v = "Go to definition in a split",
		a = "Swap next param",
		A = "Swap previous param",
		o = { require("telescope.builtin").buffers, "Open Buffer" },
		W = { "<cmd>noautocmd w<cr>", "Save without formatting (noautocmd)" },
		-- TODO: Check it out later
		r = {
			name = "Replace (Spectre)",
			r = { "<cmd>lua require('spectre').open()<cr>", "Replace" },
			w = { "<cmd>lua require('spectre').open_visual({select_word=true})<cr>", "Replace Word" },
			f = { "<cmd>lua require('spectre').open_file_search()<cr>", "Replace Buffer" },
		},
		["="] = {
			"<cmd>:lua vim.cmd('wincmd =')<CR>",
			"Format windows",
		},
		G = {
			name = "+Git",
			k = { "<cmd>lua require 'gitsigns'.prev_hunk({navigation_message = false})<cr>", "Prev Hunk" },
			l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
			p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
			r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
			j = { "<cmd>lua require 'gitsigns'.next_hunk({navigation_message = false})<cr>", "Next Hunk" },
			hs = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
			u = {
				"<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
				"Undo Stage Hunk",
			},
			o = { require("telescope.builtin").git_status, "Open changed file" },
			b = { require("telescope.builtin").git_branches, "Checkout branch" },
			U = { ":UndotreeToggle<CR>", "Toggle UndoTree" },
		},
		l = {
			name = "+LSP",
			a = { vim.lsp.buf.code_action, "Code Action" },
			A = { vim.lsp.buf.range_code_action, "Range Code Actions" },
			s = { vim.lsp.buf.signature_help, "Display Signature Information" },
			r = { vim.lsp.buf.rename, "Rename all references" },
			i = { require("telescope.builtin").lsp_implementations, "Implementation" },
			l = { "<cmd>TroubleToggle document_diagnostics<cr>", "Document Diagnostics (Trouble)" },
			L = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Workspace Diagnostics (Trouble)" },
			w = { require("telescope.builtin").diagnostics, "Diagnostics" },
			t = { require("telescope").extensions.refactoring.refactors, "Refactor" },
			c = { require("config.utils").copyFilePathAndLineNumber, "Copy File Path and Line Number" },

			-- W = {
			-- 	name = "+Workspace",
			-- 	a = { vim.lsp.buf.add_workspace_folder, "Add Folder" },
			-- 	r = { vim.lsp.buf.remove_workspace_folder, "Remove Folder" },
			-- 	l = {
			-- 		function()
			-- 			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			-- 		end,
			-- 		"List Folders",
			-- 	},
			-- },
		},
		s = {
			name = "+Search",
			f = { "<cmd>Telescope find_files<cr>", "Find File (CWD)" },
			h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
			H = { "<cmd>Telescope highlights<cr>", "Find highlight groups" },
			R = { "<cmd>Telescope registers<cr>", "Registers" },
			t = { "<cmd>Telescope live_grep<cr>", "Live Grep" },
			T = { "<cmd>Telescope grep_string<cr>", "Grep String" },
			k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
			c = { "<cmd>Telescope commands<cr>", "Commands" },
			l = { "<cmd>Telescope resume<cr>", "Resume last search" },
			S = { "<cmd>Telescope git_stash<cr>", "Git stash" },
			e = { "<cmd>Telescope frecency<cr>", "Frecency" },
			b = { "<cmd>Telescope buffers<cr>", "Buffers" },
			-- d = {
			--   name = "+DAP",
			--   c = { "<cmd>Telescope dap commands<cr>", "Dap Commands" },
			--   b = { "<cmd>Telescope dap list_breakpoints<cr>", "Dap Breakpoints" },
			--   g = { "<cmd>Telescope dap configurations<cr>", "Dap Configurations" },
			--   v = { "<cmd>Telescope dap variables<cr>", "Dap Variables" },
			--   f = { "<cmd>Telescope dap frames<cr>", "Dap Frames" },
			-- },
		},
		T = {
			name = "+Todo",
			t = { "<cmd>TodoTelescope<cr>", "Todo" },
			T = { "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", "Todo/Fix/Fixme" },
			x = { "<cmd>TodoTrouble<cr>", "Todo (Trouble)" },
			X = { "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr><cr>", "Todo/Fix/Fixme (Trouble)" },
		},
		-- d = {
		-- 	name = "Debug",
		-- 	b = { require("dap").toggle_breakpoint, "Breakpoint" },
		-- 	c = { require("dap").continue, "Continue" },
		-- 	i = { require("dap").step_into, "Into" },
		-- 	o = { require("dap").step_over, "Over" },
		-- 	O = { require("dap").step_out, "Out" },
		-- 	r = { require("dap").repl.toggle, "Repl" },
		-- 	l = { require("dap").run_last, "Last" },
		-- 	u = { require("dapui").toggle, "UI" },
		-- 	x = { require("dap").terminate, "Exit" },
		-- },
	},
	non_leaders = {
		gd = "Goto definition",
		gD = "Goto declaration",
		gi = "Goto implementation",
		gl = "Goto float diagnostics",
		go = "Goto type definition",
		gr = "Goto references",
	},
}
