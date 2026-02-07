local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps
---------------------

-- use jj to exit insert mode
-- keymap.set("i", "jj", "<ESC>")
keymap.set("i", "kj", "<ESC>")

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>")

-- delete single character without copying into register
keymap.set("n", "x", '"_x')

-- paste without coping in register
keymap.set("x", "P", '"_dP')

-- save the file with Ctrl + s
keymap.set("n", "<C-s>", ":w<cr>")
keymap.set("i", "<C-s>", "<ESC>:w<cr>")
-- save with command s
keymap.set("n", "<D-s>", ":w<cr>")
keymap.set("i", "<D-s>", "<ESC>:w<cr>")

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<c-a>") -- increment
keymap.set("n", "<leader>-", "<C-x>") -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v")     -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s")     -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=")     -- make split windows equal width & height
keymap.set("n", "<leader>sx", function()
	local ok, lib = pcall(require, "diffview.lib")
	if ok and lib.get_current_view() then
		vim.cmd("DiffviewClose")
		return
	end
	vim.cmd("close")
end) -- close current split window or Diffview

-- replace " or ' with `
keymap.set("v", "<leader>`", [[:s/['"]/`/g<CR>]], { noremap = true })

local replace_newlines = [[<Esc>:s/\\n/\r/g<CR>]]
keymap.set("v", "<leader>nr", replace_newlines, { noremap = true })

----------------------
-- Plugin Keybinds
----------------------

-- vim-maximizer
keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>") -- toggle split window maximization

-- restart lsp server
keymap.set("n", "<leader>rs", ":LspRestart<CR>") -- mapping to restart lsp if necessary

keymap.set("n", "<leader>ha", function()
	local harpoon = require("harpoon")
	harpoon:list():add()
end) -- add item to list

keymap.set("n", "<leader>hm", function()
	local harpoon = require("harpoon")
	harpoon.ui:toggle_quick_menu(harpoon:list())
end) -- toggle harpoon quick menu

keymap.set("n", "<leader>h1", function()
	require("harpoon"):list():select(1)
end)

keymap.set("n", "<leader>h2", function()
	require("harpoon"):list():select(2)
end)

keymap.set("n", "<leader>h3", function()
	require("harpoon"):list():select(3)
end)

keymap.set("n", "<leader>h4", function()
	require("harpoon"):list():select(4)
end)

keymap.set("n", "<leader>h5", function()
	require("harpoon"):list():select(5)
end)
