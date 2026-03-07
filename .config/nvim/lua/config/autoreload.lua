local group = vim.api.nvim_create_augroup("LightExternalFileReload", { clear = true })

local min_check_interval_ms = 700
local last_checked_at = {}

local function can_check_buffer(bufnr)
	if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_buf_is_loaded(bufnr) then
		return false
	end

	if vim.bo[bufnr].buftype ~= "" then
		return false
	end

	local name = vim.api.nvim_buf_get_name(bufnr)
	if name == "" or vim.fn.filereadable(name) ~= 1 then
		return false
	end

	return true
end

local function check_buffer(bufnr)
	if not can_check_buffer(bufnr) then
		return
	end

	local now = vim.uv.now()
	local last = last_checked_at[bufnr] or 0
	if now - last < min_check_interval_ms then
		return
	end
	last_checked_at[bufnr] = now

	pcall(vim.cmd, ("checktime %d"):format(bufnr))
end

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
	group = group,
	callback = function(args)
		-- Skip command-line mode checks to avoid unnecessary churn.
		if vim.fn.mode(1):sub(1, 1) == "c" then
			return
		end

		check_buffer(args.buf)
	end,
})

vim.api.nvim_create_autocmd("FileChangedShell", {
	group = group,
	callback = function(args)
		local bufnr = args.buf
		if not vim.api.nvim_buf_is_valid(bufnr) then
			return
		end

		if vim.bo[bufnr].modified then
			vim.v.fcs_choice = ""
			local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":~:.")
			vim.schedule(function()
				vim.notify("External update skipped for " .. name .. " (unsaved changes in buffer)", vim.log.levels.WARN)
			end)
			return
		end

		if vim.v.fcs_reason == "deleted" then
			vim.v.fcs_choice = "ask"
			return
		end

		vim.v.fcs_choice = "reload"
	end,
})
