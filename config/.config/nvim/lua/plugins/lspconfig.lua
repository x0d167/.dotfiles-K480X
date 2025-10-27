return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"mason-org/mason.nvim",
		"mason-org/mason-lspconfig.nvim",
	},
	config = function()
		vim.g.mason_use_system_curl = true
		require("mason").setup()

		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"ruff",
				"pylsp",
				"clangd",
			},
			automatic_enable = true,
		})

		local lspconfig = require("lspconfig")

		-- Ruff LSP: fast linter/formatter/code actions
		vim.lsp.config.ruff = {
			commands = {
				RuffAutofix = {
					function()
						vim.lsp.buf.execute({
							command = "ruff.applyAutofix",
							arguments = {
								{ uri = vim.uri_from_bufnr(0) },
							},
						})
					end,
					description = "Ruff: Fix all auto-fixable problems",
				},
				RuffOrganizeImports = {
					function()
						vim.lsp.buf.execute({
							command = "ruff.applyOrganizeImports",
							arguments = {
								{ uri = vim.uri_from_bufnr(0) },
							},
						})
					end,
					description = "Ruff: Organize imports",
				},
			},
		}
		vim.lsp.enable("ruff")

		-- Pylsp: disable overlapping linters/formatters
		vim.lsp.config.pylsp = {
			settings = {
				pylsp = {
					plugins = {
						pyflakes = { enabled = false },
						pycodestyle = { enabled = false },
						autopep8 = { enabled = false },
						yapf = { enabled = false },
						mccabe = { enabled = false },
						pylsp_mypy = { enabled = false },
						pylsp_black = { enabled = false },
						pylsp_isort = { enabled = false },
					},
				},
			},
		}
		vim.lsp.enable("pylsp")

		-- Bash
		vim.lsp.config.bashls = {}
		vim.lsp.enable("bashls")
		-- JSON
		vim.lsp.config.jsonls = {}
		vim.lsp.enable("jsonls")
		-- Lua (Neovim config)
		vim.lsp.config.lua_ls = {
			settings = {
				Lua = {
					runtime = { version = "LuaJIT" },
					diagnostics = { globals = { "vim" } },
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
						checkThirdParty = false,
					},
					telemetry = { enable = false },
				},
			},
		}
	end,
}
