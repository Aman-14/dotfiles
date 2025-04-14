local M = {}

-- Get the GitHub URL for the current file and line
local function get_git_origin()
	local current_file = vim.fn.expand("%:p")
	local current_line = vim.fn.line(".")
	local is_git_repo = vim.fn.system("git rev-parse --is-inside-work-tree"):match("true")

	if not is_git_repo then
		return
	end

	local current_repo = vim.fn.systemlist("git remote get-url origin")[1]
	local current_branch = vim.fn.systemlist("git rev-parse --abbrev-ref HEAD")[1]

	-- Handle different GitHub URL formats
	current_repo = string.gsub(current_repo, "git@github%.com%-[%w-]+:(.*)", "https://github.com/%1")
	current_repo = string.gsub(current_repo, "git@github%.com:(.*)", "https://github.com/%1")
	current_repo = current_repo:gsub("%.git$", "")

	-- Remove leading system path to repository root
	local repo_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
	if repo_root then
		current_file = current_file:sub(#repo_root + 2)
	end

	return {
		full_url = string.format("%s/blob/%s/%s#L%s", current_repo, current_branch, current_file, current_line),
		url = string.format("%s/blob/%s", current_repo, current_branch),
	}
end

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
M.gitOriginUrlPath = function()
	local result = get_git_origin()
	if not result then
		print("Not in a Git repository")
		return
	end
	vim.fn.setreg("+", result.full_url)
	print("Copied to clipboard: " .. result.url)
end

-- Open the current file in GitHub (or file path if not in git repo)
M.openGitOrigin = function()
	local result = get_git_origin()
	if not result then
		print("Not in a Git repository")
		return
	end
	-- Use xdg-open on Linux, open on macOS
	local open_cmd = vim.fn.has("mac") == 1 and "open" or "xdg-open"
	vim.fn.system(string.format("%s '%s'", open_cmd, result.full_url))
	print("Opened in browser: " .. result.full_url)
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
		hidden = true,
	})
end

M.organizeImports = function()
	local bufnr = vim.api.nvim_get_current_buf()
	local filename = vim.api.nvim_buf_get_name(bufnr)
	local clients = vim.lsp.get_clients({ bufnr = bufnr })

	if filename:match("%.py$") then
		for _, client in ipairs(clients) do
			if client.name == "ruff" then
				-- Run fixAll first
				vim.lsp.buf.code_action({
					context = {
						diagnostics = {},
						only = { "source.fixAll" },
					},
					apply = true,
				})
				-- Schedule organizeImports to run after fixAll completes
				vim.defer_fn(function()
					vim.lsp.buf.code_action({
						context = {
							diagnostics = {},
							only = { "source.organizeImports" },
						},
						apply = true,
					})
				end, 100)
				return
			end
		end
	end

	if filename:match("%.ts$") or filename:match("%.js$") or filename:match("%.tsx$") or filename:match("%.jsx$") then
		vim.cmd("TSToolsOrganizeImports")
	end
end

M.addFilesToPromptFile = function()
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	require("telescope.builtin").find_files({
		prompt_title = "Select Files to Add to Prompt",
		attach_mappings = function(prompt_bufnr, map)
			actions.select_default:replace(function()
				-- Get the current picker
				local current_picker = action_state.get_current_picker(prompt_bufnr)
				-- Get selections from the current picker
				local selections = current_picker:get_multi_selection()

				local files_to_process
				if #selections > 0 then
					files_to_process = selections
				else
					-- If no multi-selection, get the current selection
					local selection = action_state.get_selected_entry()
					files_to_process = selection and { selection } or {}
				end

				if #files_to_process == 0 then
					print("No files selected.")
					actions.close(prompt_bufnr)
					return
				end

				local combined_content = {}
				local total_files = #files_to_process

				for i, entry in ipairs(files_to_process) do
					local file_path = entry.path or entry.value
					if file_path then
						local file_name = vim.fn.fnamemodify(file_path, ":t")
						local file_content_lines = vim.fn.readfile(file_path)
						if file_content_lines then
							local separator = string.format("--------- %s (%d/%d) ---------", file_name, i, total_files)
							table.insert(combined_content, separator)
							table.insert(combined_content, table.concat(file_content_lines, "\n"))
						else
							print("Error reading file: " .. file_path)
						end
					end
				end

				actions.close(prompt_bufnr)
				if #combined_content > 0 then
					local final_string = table.concat(combined_content, "\n\n")
					vim.fn.setreg("+", final_string)
					print(string.format("Copied content of %d file(s) to clipboard.", total_files))
				else
					print("No content generated.")
				end
			end)
			return true
		end,
	})
end

return M
