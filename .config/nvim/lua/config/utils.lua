local M = {}

M.telescope_git_or_file = function()
	local path = vim.fn.expand("%:p:h")
	local git_dir = vim.fn.finddir(".git", path .. ";")
	if #git_dir > 0 then
		require("telescope.builtin").git_files()
	else
		require("telescope.builtin").find_files()
	end
end

M.toggle_set_color_column = function()
	if vim.wo.colorcolumn == "" then
		vim.wo.colorcolumn = "80"
	else
		vim.wo.colorcolumn = ""
	end
end

M.toggle_cursor_line = function()
	if vim.wo.cursorline then
		vim.wo.cursorline = false
	else
		vim.wo.cursorline = true
	end
end

M.toggle_go_test = function()
	-- Get the current buffer's file name
	local current_file = vim.fn.expand("%:p")
	if string.match(current_file, "_test.go$") then
		-- If the current file ends with '_test.go', try to find the corresponding non-test file
		local non_test_file = string.gsub(current_file, "_test.go$", ".go")
		if vim.fn.filereadable(non_test_file) == 1 then
			-- Open the corresponding non-test file if it exists
			vim.cmd.edit(non_test_file)
		else
			print("No corresponding non-test file found")
		end
	else
		-- If the current file is a non-test file, try to find the corresponding test file
		local test_file = string.gsub(current_file, ".go$", "_test.go")
		if vim.fn.filereadable(test_file) == 1 then
			-- Open the corresponding test file if it exists
			vim.cmd.edit(test_file)
		else
			print("No corresponding test file found")
		end
	end
end

-- Copy the current file path and line number to the clipboard, use GitHub URL if in a Git repository
M.copyFilePathAndLineNumber = function()
	local current_file = vim.fn.expand("%:p")
	local current_line = vim.fn.line(".")
	local is_git_repo = vim.fn.system("git rev-parse --is-inside-work-tree"):match("true")

	if is_git_repo then
		local current_repo = vim.fn.systemlist("git remote get-url origin")[1]
		local current_branch = vim.fn.systemlist("git rev-parse --abbrev-ref HEAD")[1]

		current_repo = string.gsub(current_repo, "git@github%.com%-[%w-]+:(.*)", "https://github.com/%1")
		current_repo = current_repo:gsub("%.git$", "")

		-- Remove leading system path to repository root
		local repo_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
		if repo_root then
			current_file = current_file:sub(#repo_root + 2)
		end

		local url = string.format("%s/blob/%s/%s#L%s", current_repo, current_branch, current_file, current_line)
		vim.fn.setreg("+", url)
		print("Copied to clipboard: " .. url)
	else
		-- If not in a Git directory, copy the full file path
		vim.fn.setreg("+", current_file .. "#L" .. current_line)
		print("Copied full path to clipboard: " .. current_file .. "#L" .. current_line)
	end
end

M.getPythonPath = function()
	local cwd = vim.fn.getcwd() -- Get current working directory
	local dot_venv_path = cwd .. "/.venv/bin/python"
	if vim.fn.filereadable(dot_venv_path) == 1 then
		return dot_venv_path
	end
	local venv_path = cwd .. "/venv/bin/python"
	if vim.fn.filereadable(venv_path) == 1 then
		return venv_path
	end

	-- Check if Conda environment is active
	local conda_prefix = os.getenv("CONDA_PREFIX")
	if conda_prefix then
		return conda_prefix .. "/bin/python" -- Conda python binary path
	end

	-- Fall back to system python if no venv or conda environment is found
	return vim.fn.executable("python3") == 1 and "python3" or "python"
end

M.telescope_env_files = function()
	require("telescope.builtin").find_files({
		prompt_title = "Find .env Files",
		find_command = { "fd", ".env*", "-d", "1", "-H", "-I" },
		hidden = true
	})
end

return M
