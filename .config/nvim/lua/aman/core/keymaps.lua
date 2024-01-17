-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps
---------------------

vim.api.nvim_set_keymap(
	"n",
	"<leader>cdd",
	':lua local node = require("nvim-tree.lib").get_node_at_cursor() if node and node.type == "directory" then vim.cmd("cd " .. node.absolute_path) print("cd " .. node.absolute_path) end<CR>',
	{ noremap = true, silent = true }
)

-- use jj to exit insert mode
keymap.set("i", "jj", "<ESC>")
keymap.set("i", "kj", "<ESC>")

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>")

-- delete single character without copying into register
keymap.set("n", "x", '"_x')

-- paste without coping in register
keymap.set("x", "<leader>p", '"_dP')

-- save the file with Ctrl + s
keymap.set("n", "<C-s>", ":w<cr>")
keymap.set("i", "<C-s>", "<ESC>:w<cr>")

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>") -- increment
keymap.set("n", "<leader>-", "<C-x>") -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v") -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s") -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=") -- make split windows equal width & height
keymap.set("n", "<leader>sx", ":close<CR>") -- close current split window

keymap.set("n", "<leader>to", ":tabnew<CR>") -- open new tab
keymap.set("n", "<leader>tx", ":tabclose<CR>") -- close current tab
keymap.set("n", "<leader>tn", ":tabn<CR>") --  go to next tab
keymap.set("n", "<leader>tp", ":tabp<CR>") --  go to previous tab

-- replace " or ' with `
keymap.set("v", "<leader>`", [[:s/['"]/`/g<CR>]], { noremap = true })

local replace_newlines = [[<Esc>:s/\\n/\r/g<CR>]]
keymap.set("v", "<leader>nr", replace_newlines, { noremap = true })

----------------------
-- Plugin Keybinds
----------------------

-- vim-maximizer
keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>") -- toggle split window maximization

-- nvim-tree
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>") -- toggle file explorer

-- telescope
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>") -- find files within current working directory, respects .gitignore
keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>") -- find string in current working directory as you type
keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>") -- find string under cursor in current working directory
keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>") -- list open buffers in current neovim instance
keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>") -- list available help tags
keymap.set("n", "<leader>fp", "<cmd>Telescope project<cr>") -- project plugin

-- telescope git commands
keymap.set("n", "<leader>tgc", "<cmd>Telescope git_commits<cr>") -- list all git commits (use <cr> to checkout) ["gc" for git commits]
keymap.set("n", "<leader>tgfc", "<cmd>Telescope git_bcommits<cr>") -- list git commits for current file/buffer (use <cr> to checkout) ["gfc" for git file commits]
keymap.set("n", "<leader>tgb", "<cmd>Telescope git_branches<cr>") -- list git branches (use <cr> to checkout) ["gb" for git branch]
keymap.set("n", "<leader>tgs", "<cmd>Telescope git_status<cr>") -- list current changes per file with diff preview ["gs" for git status]

-- fugitive git keymaps
keymap.set("n", "<leader>gs", ":leftabove vert G<CR>") -- git status
keymap.set("n", "<leader>gc", ":Git commit<CR>") -- git commit
keymap.set("n", "<leader>gp", ":Git push<CR>") -- git push
keymap.set("n", "<leader>gp", [[:Git push -u origin @<CR>]]) -- git push origin

keymap.set("n", "<leader>gd", ":Gdiff<CR>") -- git diff

-- restart lsp server (not on youtube nvim video)
keymap.set("n", "<leader>rs", ":LspRestart<CR>") -- mapping to restart lsp if necessary

-- harpoon keybinds
keymap.set("n", "<leader>ha", ":lua require('harpoon.mark').add_file()<CR>") -- add current file to harpoon list
keymap.set("n", "<leader>hm", ":lua require('harpoon.ui').toggle_quick_menu()<CR>") -- toggle harpoon quick menu
keymap.set("n", "<leader>h1", ":lua require('harpoon.ui').nav_file(1)<CR>") -- go to file 1 in harpoon list
keymap.set("n", "<leader>h2", ":lua require('harpoon.ui').nav_file(2)<CR>") -- go to file 2 in harpoon list
keymap.set("n", "<leader>h3", ":lua require('harpoon.ui').nav_file(3)<CR>") -- go to file 3 in harpoon list
keymap.set("n", "<leader>h4", ":lua require('harpoon.ui').nav_file(4)<CR>") -- go to file 4 in harpoon list
keymap.set("n", "<leader>h5", ":lua require('harpoon.ui').nav_file(5)<CR>") -- go to file 5 in harpoon list
keymap.set("n", "<leader>h6", ":lua require('harpoon.ui').nav_file(6)<CR>") -- go to file 6 in harpoon list
keymap.set("n", "<leader>h7", ":lua require('harpoon.ui').nav_file(7)<CR>") -- go to file 7 in harpoon list
