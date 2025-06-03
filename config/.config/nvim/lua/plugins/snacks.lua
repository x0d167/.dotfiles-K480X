-- plugins/snacks.lua
return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		animate = { enabled = true },
		buffdelete = { enabled = true },
		bigfile = { enabled = true },
		explorer = { enabled = true },
		image = { enabled = true },
		indent = { enabled = true },
		lazygit = { enabled = true },
		notifier = {
			enabled = true,
			timeout = 5000,
			max_width = 60,
			render = "default",
			stages = "fade",
			history = true,
		},
		picker = { enabled = true },
		profiler = { enabled = true },
		quickfile = { enabled = true },
		scope = { enabled = true },
		scroll = { enabled = true },
		statuscolumn = { enabled = true },
		toggle = { enabled = true },
		words = { enabled = true },
		dashboard = {
			enabled = true,
			width = math.min(math.max(vim.o.columns - 10, 40), 60),
			preset = {
				keys = function()
					local enabled = vim.o.lines >= 21
					return {
						{ icon = "󰈔 ", key = "n", desc = "New File", action = ":ene | startinsert" },
						{
							icon = "󱔗 ",
							key = "r",
							desc = "Recent Files",
							action = ":lua Snacks.dashboard.pick('oldfiles')",
						},
						{ icon = " ", key = "l", desc = "Load Session", action = ":Session load", enabled = false },
						{
							icon = "󰱼 ",
							key = "f",
							desc = "Find File",
							action = ":lua Snacks.dashboard.pick('files')",
						},
						{
							icon = "󰺮 ",
							key = "g",
							desc = "Find Text",
							action = ":lua Snacks.dashboard.pick('live_grep')",
						},
						{
							icon = " ",
							key = "c",
							desc = "Config",
							action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
						},
						{
							icon = " ",
							key = "p",
							desc = "Check Plugins",
							action = ":Lazy",
							enabled = package.loaded.lazy ~= nil,
						},
						{ icon = " ", key = "h", desc = "Check Health", action = ":checkhealth", enabled = enabled },
						{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
					}
				end,
				header = table.concat({
					[[   █  █   ]],
					[[   █ ██   ]],
					[[   ████   ]],
					[[   ██ ███   ]],
					[[   █  █   ]],
					[[             ]],
					[[ n e o v i m ]],
				}, "\n"),
			},
			sections = {
				{ section = "header" },
				{ section = "keys", gap = 1, padding = 1 },
				function()
					local version = "NVIM v"
						.. vim.version().major
						.. "."
						.. vim.version().minor
						.. "."
						.. vim.version().patch
					local stats = require("lazy").stats()
					local plugin_stats = {
						count = stats.count,
						updates = stats.updates or 0,
						startuptime = string.format("%.1f", stats.startuptime or 0),
					}
					local date = os.date("%Y.%m.%d")
					return {
						align = "center",
						text = {
							{ " ", hl = "footer" },
							{ version, hl = "NonText" },
							{ "    ", hl = "footer" },
							{ tostring(plugin_stats.count), hl = "NonText" },
							{ "   󰛕 ", hl = "footer" },
							{ plugin_stats.startuptime .. " ms", hl = "NonText" },
							{ "    ", hl = "footer" },
							{ date, hl = "NonText" },
						},
						padding = 1,
					}
				end,
				function()
					local hour = tonumber(os.date("%H"))
					local part_id = math.floor((hour + 6) / 8) + 1
					local day_part = ({ "evening", "morning", "afternoon", "evening" })[part_id]
					local username = vim.loop.os_getenv("USER") or "user"
					return {
						align = "center",
						text = { ("Good %s, %s"):format(day_part, username), hl = "NonText" },
					}
				end,
			},
		},
	},
	config = function(_, opts)
		local snacks = require("snacks")
		if vim.o.lines < 37 then
			opts.dashboard.sections[2].gap = 0
		end
		if vim.o.lines < 28 then
			opts.dashboard.preset.header = "N E O V I M"
		end
		snacks.setup(opts)
		vim.defer_fn(function()
			snacks.dashboard.update()
		end, 500)
		vim.api.nvim_create_autocmd("User", {
			pattern = { "LazyCheck", "LazyUpdate" },
			callback = function()
				for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
					if vim.api.nvim_get_option_value("filetype", { buf = bufnr }) == "snacks_dashboard" then
						snacks.dashboard.update()
					end
				end
			end,
		})
	end,
}
