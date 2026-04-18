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
		settings = {
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
	pyright = {
		settings = {
			python = {
				pythonPath = require("config.utils").getPythonPath(),
			},
		},
	},
	-- ty = {},
	ruff = {},
	tailwindcss = {
		root_markers = {
			"tailwind.config.js",
			"tailwind.config.cjs",
			"tailwind.config.ts",
			"postcss.config.js",
			"postcss.config.mjs",
			"postcss.config.ts",
		},
	},
	cssls = {},
	solidity_ls_nomicfoundation = {},
	-- gopls = {},
	eslint = {},
	oxlint = { mason = false },
	oxfmt = { mason = false },
	biome = {},
	taplo = {}, -- lsp for toml
	prismals = {},
	ruby_lsp = {
		init_options = {
			formatter = "standard",
			linters = { "standard" },
		},
	},
}
