vim.g.aman_color_scheme = "rose-pine"

-- require("catppuccin").setup()
-- require("tokyonight").setup()
require("rose-pine").setup({
	disable_background = true,
	disable_float_background = true,
})

vim.opt.background = "dark"
vim.cmd("colorscheme " .. vim.g.aman_color_scheme)
