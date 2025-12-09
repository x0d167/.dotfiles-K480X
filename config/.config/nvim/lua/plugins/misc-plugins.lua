return {

	-- Plugin Manager
	{ "folke/lazy.nvim", version = false },

	-- Treesitter for syntax highlighting
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		opts = {
			ensure_installed = {
				"python",
				"lua",
				"vim",
				"bash",
				"json",
				"rust",
				"regex",
				"toml",
				"yaml",
				"markdown",
				"markdown_inline",
				"latex",
				"html",
				"haskell",
			},
			highlight = {
				enabled = true,
				disable = { "latex" },
			},
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},

	-- Mason for installing LSPs and tools
	{
		"mason-org/mason.nvim",
		build = function()
			vim.cmd("MasonUpdate")
		end,
		config = function()
			require("mason").setup()
		end,
	},

	-- For when you can't remember keys
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			layout = {
				spacing = 3,
			},
			win = {
				no_overlap = true,
				width = 50,
				col = 2,
				row = math.huge,
				padding = { 1, 2 },
				title = true,
				title_pos = "center",
				zindex = 1000,
				bo = {},
				wo = {},
			},
			notify = true,
			plugins = {
				marks = true,
				registers = true,
				spelling = {
					enabled = true,
					suggestions = 20,
				},
			},
		},
	},

	-- quick navigation
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		---@type Flash.Config
		opts = {},
        -- stylua: ignore
        keys = {
            { "<M-f>", mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
            { "<M-F>", mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
            { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
            { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
        },
	},

	{
		"projekt0n/github-nvim-theme",
		name = "github-theme",
		-- enabled = false,
		lazy = false,
		priority = 1000,
		config = function()
			require("github-theme").setup({})
			vim.cmd("colorscheme github_dark_default")
			vim.cmd([[
            hi Normal guibg=NONE ctermbg=NONE
            hi NormalNC guibg=NONE ctermbg=NONE
            hi SignColumn guibg=NONE ctermbg=NONE
            hi VertSplit guibg=NONE ctermbg=NONE
            hi Pmenu guibg=NONE ctermbg=NONE
            hi PmenuSel guibg=NONE ctermbg=NONE
            hi FloatBorder guibg=NONE ctermbg=NONE
            hi NormalFloat guibg=NONE ctermbg=NONE
            hi TablineFill guibg=NONE ctermbg=NONE
            hi StatusLine guibg=NONE ctermbg=NONE guifg=#FFFFFF ctermfg=White
            hi StatusLineNC guibg=NONE ctermbg=NONE guifg=#888888 ctermfg=Gray
            ]])
		end,
	},

	{
		-- High-performance color highlighter
		"norcalli/nvim-colorizer.lua",
		event = "VeryLazy",
		config = function()
			require("colorizer").setup()
		end,
	},

	-- Adds git related signs to the gutter, as well as utilities for managing changes
	{
		"lewis6991/gitsigns.nvim",
		events = "VeryLazy",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "~" },
			},
			signs_staged = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "~" },
			},
		},
	},

	{
		"echasnovski/mini.surround",
		event = "VeryLazy",
		opts = {
			mappings = {
				add = "gsa", -- Add surrounding in Normal and Visual modes
				delete = "gsd", -- Delete surrounding
				find = "gsf", -- Find surrounding (to the right)
				find_left = "gsF", -- Find surrounding (to the left)
				highlight = "gsh", -- Highlight surrounding
				replace = "gsr", -- Replace surrounding
				update_n_lines = "gsn", -- Update `n_lines`
			},
		},
	},

	{
		"folke/trouble.nvim",
		cmd = { "Trouble" },
		opts = {
			modes = {
				lsp = {
					win = { position = "right" },
				},
			},
		},
		keys = {
			{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
			{ "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
			{ "<leader>cs", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols (Trouble)" },
			{
				"<leader>cS",
				"<cmd>Trouble lsp toggle<cr>",
				desc = "LSP references/definitions/... (Trouble)",
			},
			{ "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
			{ "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
			{
				"[q",
				function()
					if require("trouble").is_open() then
						require("trouble").prev({ skip_groups = true, jump = true })
					else
						local ok, err = pcall(vim.cmd.cprev)
						if not ok then
							vim.notify(err, vim.log.levels.ERROR)
						end
					end
				end,
				desc = "Previous Trouble/Quickfix Item",
			},
			{
				"]q",
				function()
					if require("trouble").is_open() then
						require("trouble").next({ skip_groups = true, jump = true })
					else
						local ok, err = pcall(vim.cmd.cnext)
						if not ok then
							vim.notify(err, vim.log.levels.ERROR)
						end
					end
				end,
				desc = "Next Trouble/Quickfix Item",
			},
		},
	},

	{
		"akinsho/toggleterm.nvim",
		version = "*",
		event = "VeryLazy",
		config = function()
			require("toggleterm").setup({
				size = 20,
				open_mapping = [[<c-t>]],
				shade_filetypes = {},
				shade_terminals = true,
				shading_factor = 2,
				start_in_insert = true,
				persist_size = false,
				direction = "float",
				close_on_exit = true,
				shell = vim.o.shell,
				float_opts = {
					border = "curved",
					winblend = 0,
					highlights = {
						Normal = {
							guibg = "1e1e2eAA",
						},
						NormalFloat = {
							link = "Normal",
						},
						border = "Normal",
						-- background = "Normal",
					},
				},
			})
		end,
	},

	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		optional = true,
		opts = {
			vim.keymap.set("n", "]t", function()
				require("todo-comments").jump_next()
			end, { desc = "Next todo comment" }),

			vim.keymap.set("n", "[t", function()
				require("todo-comments").jump_prev()
			end, { desc = "Previous todo comment" }),

			vim.keymap.set("n", "]t", function()
				require("todo-comments").jump_next({ keywords = { "ERROR", "WARNING" } })
			end, { desc = "Next error/warning todo comment" }),
		},
		keys = {
			{
				"<leader>st",
				function()
					Snacks.picker.todo_comments()
				end,
				desc = "Todo",
			},
			{
				"<leader>sT",
				function()
					Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } })
				end,
				desc = "Todo/Fix/Fixme",
			},
		},
	},

	{ "nvim-tree/nvim-web-devicons", opts = {} },

	-- Aspirational...
	{
		"mrcjkb/rustaceanvim",
		version = "^6", -- Recommended
		lazy = false, -- This plugin is already lazy
	},

	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons

		---@module 'render-markdown'
		---@type render.md.UserConfig

		opts = {
			completions = { lsp = { enabled = true } },
			file_types = { "markdown", "vimwiki" },
			code = { enabled = true },
			bullet = { enabled = true, icon = "•" },
			quote = { enabled = true },
			latex = { enabled = true },
		},
	},

	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>cf",
				function()
					require("conform").format({ async = true })
				end,
				mode = "",
				desc = "Format buffer",
			},
		},
		---@module "conform"
		---@type conform.setupOpts
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "ruff_format", "ruff_fix", "ruff_organize_imports" },
				bash = { "shfmt" },
				shell = { "shfmt", "shellcheck" },
				rust = { "rustfmt" },
			},
			default_format_opts = {
				lsp_format = "fallback",
			},
			format_on_save = { timeout_ms = 500 },
			formatters = {
				shfmt = {
					prepend_args = { "-i", "2" },
				},
			},
		},
		init = function()
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		end,
	},

	{
		"jeffkreeftmeijer/vim-numbertoggle",
	},
	{
		"supermaven-inc/supermaven-nvim",
		enabled = true,
		config = function()
			require("supermaven-nvim").setup({})
		end,
	},
	-- {
	-- 	"echaya/neowiki.nvim",
	-- 	opts = {
	-- 		wiki_dirs = {
	-- 			-- neowiki.nvim supports both absolute and tilde-expanded paths
	-- 			{ name = "wiki", path = "~/docs/wiki/" },
	-- 		},
	-- 	},
	-- 	keys = {
	-- 		{ "<leader>ww", "<cmd>lua require('neowiki').open_wiki()<cr>", desc = "Open Wiki" },
	-- 		{
	-- 			"<leader>wW",
	-- 			"<cmd>lua require('neowiki').open_wiki_floating()<cr>",
	-- 			desc = "Open Wiki in Floating Window",
	-- 		},
	-- 		{ "<leader>wT", "<cmd>lua require('neowiki').open_wiki_new_tab()<cr>", desc = "Open Wiki in Tab" },
	-- 	},
	-- },
	{
		"vimwiki/vimwiki",
		lazy = false,
		event = "VeryLazy",
		init = function()
			vim.g.vimwiki_list = {
				{
					path = "~/docs/wiki/",
					syntax = "markdown",
					ext = ".md",
					diary_rel_path = "logs",
					diary_date_format = "%Y%m%d",
				},
			}
			vim.g.vimwiki_global_ext = 0
			vim.g.vimwiki_markdown_link_ext = 1
			vim.g.vimwiki_conceal_pre = 1
			vim.g.vimwiki_auto_diary_index = 1
			vim.cmd([[
            augroup vimwiki_markdown_links
            autocmd!
            autocmd FileType markdown setlocal isfname+=@-@ isfname-==#
            augroup END
            ]])
		end,
		config = function()
			-- ensure Treesitter treats vimwiki as markdown
			vim.treesitter.language.register("markdown", "vimwiki")
		end,
		keys = {
			{ "<leader>ww", "<cmd>VimwikiIndex<CR>", desc = "Open Vimwiki index" },
			{ "<leader>wt", "<cmd>VimwikiTabIndex<CR>", desc = "Open Vimwiki in new tab" },
			{ "<leader>ws", "<cmd>VimwikiUISelect<CR>", desc = "Select Vimwiki" },
			{
				"<leader>wf",
				function()
					require("snacks").picker.files({ cwd = "~/docs/wiki" })
				end,
				desc = "Search Vimwiki files",
			},
		},
	},
	{ "plasticboy/vim-markdown", ft = "markdown", dependencies = { "godlygeek/tabular" } },
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
		-- use opts = {} for passing setup options
		-- this is equivalent to setup({}) function
	},
	{ "mattn/calendar-vim" },
	{
		"lervag/vimtex",
		lazy = false, -- we don't want to lazy load VimTeX
		init = function()
			-- VimTeX configuration goes here, e.g.
			vim.g.vimtex_view_method = "zathura"
			vim.g.vimtex_compiler_method = "tectonic"
		end,
	},
	{
		"chomosuke/typst-preview.nvim",
		lazy = false, -- or ft = 'typst'
		version = "1.*",
		opts = {}, -- lazy.nvim will implicitly calls `setup {}`
	},
}
