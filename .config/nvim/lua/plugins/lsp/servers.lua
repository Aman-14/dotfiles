return {
	jsonls = {
		settings = {
			json = {
				schema = require("schemastore").json.schemas(),
				validate = { enable = true },
			},
		},
	},
	lua_ls = {
		Lua = {
			telemetry = { enable = false },
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				-- make language server aware of runtime files
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
		},
	},
	bashls = {
		filetypes = { "sh", "zsh" },
	},
	vimls = {
		filetypes = { "vim" },
	},
	yamlls = {
		cmd = { "yaml-language-server", "--stdio" },
		filetypes = { "yaml" },
	},
	tsserver = nil,
	pyright = {},
	ruff_lsp = {},
	tailwindcss = {
		root_dir = require("lspconfig.util").root_pattern(
			"tailwind.config.js",
			"tailwind.config.cjs",
			"tailwind.config.ts",
			"postcss.config.js",
			"postcss.config.ts"
		),
	},
	cssls = {},
	solidity_ls_nomicfoundation = {},
	gopls = {},
	eslint = {},
	taplo = {}, -- lsp for toml
}
