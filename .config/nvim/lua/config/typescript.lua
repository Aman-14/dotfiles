local M = {}

M.ts_filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact" }
M.tsserver_filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" }
M.root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" }

local function path_join(...)
	return table.concat({ ... }, "/")
end

local function path_exists(path)
	return vim.uv.fs_stat(path) ~= nil
end

local function file_exists(path)
	local stat = vim.uv.fs_stat(path)
	return stat and (stat.type == "file" or stat.type == "link")
end

local function ancestor_with(root, ...)
	local dir = root
	while dir and dir ~= "" do
		local candidate = path_join(dir, ...)
		if path_exists(candidate) then
			return dir, candidate
		end

		local parent = vim.fs.dirname(dir)
		if not parent or parent == dir then
			return nil
		end
		dir = parent
	end
end

local function typescript_package_json(root)
	local _, package_json = ancestor_with(root, "node_modules", "typescript", "package.json")
	return package_json
end

function M.project_root(bufnr)
	if not vim.api.nvim_buf_get_name(bufnr):match("^/") then
		return nil
	end

	local root_dir = vim.fs.root(bufnr, M.root_markers)
	if root_dir and root_dir:match("^/") then
		return root_dir
	end
end

function M.typescript_major(root)
	local package_json = typescript_package_json(root)
	if not package_json or not file_exists(package_json) then
		return nil
	end

	local fd = io.open(package_json, "r")
	if not fd then
		return nil
	end

	local ok, package = pcall(vim.json.decode, fd:read("*a"))
	fd:close()

	if not ok or type(package) ~= "table" or type(package.version) ~= "string" then
		return nil
	end

	return tonumber(package.version:match("^(%d+)"))
end

function M.is_ts7_root(root)
	if ancestor_with(root, "node_modules", "@typescript", "native-preview") then
		return true
	end

	if ancestor_with(root, "node_modules", ".bin", "tsgo") then
		return true
	end

	local major = M.typescript_major(root)
	return major ~= nil and major >= 7
end

function M.tsserver_root_dir(bufnr, on_dir)
	local root_dir = M.project_root(bufnr)
	if root_dir and not M.is_ts7_root(root_dir) then
		on_dir(root_dir)
	end
end

function M.tsgo_root_dir(bufnr, on_dir)
	local root_dir = M.project_root(bufnr)
	if root_dir and M.is_ts7_root(root_dir) then
		on_dir(root_dir)
	end
end

function M.tsgo_cmd(root)
	local _, local_tsgo = ancestor_with(root, "node_modules", ".bin", "tsgo")
	if local_tsgo then
		return { local_tsgo, "--lsp", "--stdio" }
	end

	local major = M.typescript_major(root)
	local _, local_tsc = ancestor_with(root, "node_modules", ".bin", "tsc")
	if local_tsc and major and major >= 7 then
		return { local_tsc, "--lsp", "--stdio" }
	end

	local global_tsgo = vim.fn.exepath("tsgo")
	if global_tsgo ~= "" then
		return { global_tsgo, "--lsp", "--stdio" }
	end

	return { "tsgo", "--lsp", "--stdio" }
end

return M
