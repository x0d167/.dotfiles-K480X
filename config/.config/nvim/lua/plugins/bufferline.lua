return {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    enabled = true,
    dependencies = {
        "moll/vim-bbye",
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("bufferline").setup({
            options = {
                mode = "buffers", -- set to "tabs" to only show tabpages instead default "buffers"
                themable = true, -- allows highlight groups to be overriden i.e. sets highlights as default
                numbers = "none", -- | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
                    close_command = function(n)
                        Snacks.bufdelete(n)
                    end, -- "Bdelete! %d", -- can be a string | function, see "Mouse actions"
                    right_mouse_command = function(n)
                        Snacks.bufdelete(n)
                    end,
                    buffer_close_icon = "󰅖",
                    close_icon = "󰅖",
                    path_components = 1, -- Show only the file name without the directory
                    modified_icon = "●",
                    left_trunc_marker = "",
                    right_trunc_marker = "",
                    max_name_length = 30,
                    max_prefix_length = 30, -- prefix used when a buffer is de-duplicated
                    tab_size = 21,
                    diagnostics = "nvim_lsp",
                    diagnostics_indicator = function(count, level, diagnostics_dict, context)
                        return "("..count..")"
                    end,
                    offsets = {
                        {
                            filetype = "neo-tree",
                            text = "Neo-tree",
                            highlight = "Directory",
                            text_align = "left",
                        },
                        {
                            filetype = "snacks_layout_box",
                        },
                    },
                    diagnostics_update_in_insert = false,
                    diagnostics_update_on_event = true,
                    color_icons = true,
                    show_buffer_icons = true,
                    show_buffer_close_icons = true,
                    show_close_icon = true,
                    persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
                    separator_style = "thin", -- { "│", "│" }, -- | "thick" | "thin" | { 'any', 'any' },
                    enforce_regular_tabs = true,
                    always_show_bufferline = true,
                    icon_pinned = "󰐃",
                    minimum_padding = 1,
                    maximum_padding = 5,
                    maximum_length = 15,
                    sort_by = "insert_at_end",
                    hover = {
                        enabled = true,
                        delay = 200,
                        reveal = {'close'}
                    },
                },

                highlights = {
                    fill = {
                        bg = "none",
                    },
                    background = {
                        bg = "none",
                    },
                    buffer_selected = {
                        bg = "none",
                        italic = false,
                    },
                    buffer_visible = {
                        bg = "none",
                    },
                    separator = {
                        bg = "none",
                        fg = "none",
                    },
                    separator_selected = {
                        bg = "none",
                        fg = "none",
                    },
                    separator_visible = {
                        bg = "none",
                        fg = "none",
                    },
                    tab = {
                        bg = "none",
                    },
                    tab_selected = {
                        bg = "none",
                    },
                    tab_close = {
                        bg = "none",
                    },
                    close_button = {
                        bg = "none",
                    },
                    close_button_selected = {
                        bg = "none",
                    },
                }
            })
            -- Clear fallback highlights that might still be adding background
            vim.cmd([[
            highlight TabLineFill guibg=NONE ctermbg=NONE
            highlight TabLineSel guibg=NONE ctermbg=NONE
            highlight TabLine guibg=NONE ctermbg=NONE
            ]])
        end,
    }
