-- custom vim commands

-- autoreload file on focus
vim.cmd("au FocusGained,BufEnter * :checktime")
vim.cmd("au CursorHold,CursorHoldI * checktime")
