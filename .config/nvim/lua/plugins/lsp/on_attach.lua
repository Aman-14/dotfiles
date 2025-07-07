M = {}
M.on_attach = function(client, bufnr)
	local nmap = function(keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end

		vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
	end

	nmap("gd", require("telescope.builtin").lsp_definitions, "Goto Definition")
	nmap("gr", require("telescope.builtin").lsp_references, "Goto References")
	nmap("gi", require("telescope.builtin").lsp_implementations, "Goto Implementation")
	nmap("gt", require("telescope.builtin").lsp_type_definitions, "Type Definition")

	nmap("gl", vim.diagnostic.open_float, "Open Diagnostic Float")
	nmap("K", vim.lsp.buf.hover, "Hover Documentation")
	-- nmap("K", vim.lsp.with(vim.lsp.handlers.hover, { border = border }))
	nmap("gs", vim.lsp.buf.signature_help, "Signature Documentation")
	nmap("gD", vim.lsp.buf.declaration, "Goto Declaration")

	nmap("<leader>v", "<cmd>vsplit | lua vim.lsp.buf.definition()<cr>", "Goto Definition in Vertical Split")

	-- Auto-configure Pyright Python path when it attaches
	-- if client.name == "pyright" then
	-- 	local python_path = require("config.utils").getPythonPath()
	-- 	vim.defer_fn(function()
	-- 		vim.cmd("PyrightSetPythonPath " .. python_path)
	-- 		print("Auto-configured Pyright with Python path: " .. python_path)
	-- 	end, 1000) -- Small delay to ensure Pyright is fully initialized
	-- end
end

return M
