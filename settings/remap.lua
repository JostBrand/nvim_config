local keyset = vim.keymap.set
keyset('i', 'jj', '<Esc>', { noremap = true, silent = true })

-- Visual mode mapping for indenting using Tab and shift tab
keyset('v', '<Tab>', '>gv', { noremap = true, silent = true })
keyset('v', '<S-Tab>', '<gv', { noremap = true, silent = true })


keyset('t', '<leader><Esc>', "<C-\\><C-n><C-w>h", { silent = true })

-- LSP keybindings are set in lua/plugins/lsp.lua on_attach function
-- This ensures they're only active when LSP is attached to the buffer

keyset('n', '<leader><leader>x', '<cmd>source %<CR>')
keyset('n', '<leader>x', ':.lua <CR>')
keyset('v', '<leader>x', ':lua<CR>')

keyset('n', '<leader>p', ":pu<CR>")

-- Telescope keybindings (lazy-loaded)
keyset('n', '<C-f>', function()
    require('telescope.builtin').find_files({ hidden = true })
end, {})
keyset('n', '<leader>fc', function()
    require('telescope.builtin').find_files({
        hidden = true,
        search_dirs = { "~/.config", "~/.ssh", "~/Dokumente", "~/Downloads", "~/bkp/Sources" }
    })
end, {})
keyset('n', '<leader>fg', function() require('telescope.builtin').live_grep() end, {})
keyset('n', '<leader>fb', function() require('telescope.builtin').buffers() end, {})
keyset('n', '<leader>fh', function() require('telescope.builtin').help_tags() end, {})
keyset('n', '<leader>fr', function() require('telescope.builtin').resume() end, {})
keyset('n', '<leader>ft', function() require('telescope.builtin').treesitter() end, {})
keyset('n', '<leader>fs', function() require('telescope.builtin').grep_string() end, {})


keyset('n', '<leader>gb', function() require('telescope.builtin').git_branches() end, {})
keyset('n', '<leader>gc', function() require('telescope.builtin').git_commits() end, {})
keyset('n', '<leader>gs', function() require('telescope.builtin').git_status() end, {})

keyset('v', 'J', ":m '>+1<CR>gv=gv") -- shift lines in visual
keyset('v', 'K', ":m '<-2<CR>gv=gv")
keyset('n', '<C-d>', "<C-d>zz")      -- keep jumps centered
keyset('n', '<C-u>', "<C-u>zz")
keyset('n', 'n', "nzzzn")
keyset('n', 'N', "Nzzzn")

vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"
vim.g.undotree_SetFocusWhenToggle = 1

keyset('n', '<leader>u', vim.cmd.UndotreeToggle)

vim.cmd [[
    function! PythonifyList()
    :s/^\(.*\)$/["\1"]/
    :s/[ ,]\+/", "/g
    endfunction
    ]]



-- Map this function to a key for convenience
keyset('n', '<Leader>br', ':call PythonifyList()<CR>', { noremap = true, silent = true })
keyset('n', '<leader>mf', ':lua MiniFiles.open()<CR>', { noremap = true, silent = true })


--- Obsidian keybindings (grouped under <leader>o)
-- Quick access
keyset('n', '<leader>oo', ':ObsidianQuickSwitch<CR>', { noremap = true, silent = true, desc = 'Obsidian: Quick switch' })
keyset('n', '<leader>os', ':ObsidianSearch<CR>', { noremap = true, silent = true, desc = 'Obsidian: Search' })
keyset('n', '<leader>of', ':ObsidianFollowLink<CR>', { noremap = true, silent = true, desc = 'Obsidian: Follow link' })
keyset('n', '<leader>ob', ':ObsidianBacklinks<CR>', { noremap = true, silent = true, desc = 'Obsidian: Backlinks' })

-- Note creation
keyset('n', '<leader>on', ':ObsidianNew<CR>', { noremap = true, silent = true, desc = 'Obsidian: New note' })
keyset('n', '<leader>ot', ':ObsidianToday<CR>', { noremap = true, silent = true, desc = 'Obsidian: Today note' })
keyset('n', '<leader>oy', ':ObsidianYesterday<CR>', { noremap = true, silent = true, desc = 'Obsidian: Yesterday note' })
keyset('n', '<leader>om', ':ObsidianTomorrow<CR>', { noremap = true, silent = true, desc = 'Obsidian: Tomorrow note' })

-- Links and references
keyset('n', '<leader>ol', ':ObsidianLink<CR>', { noremap = true, silent = true, desc = 'Obsidian: Link selection' })
keyset('n', '<leader>oL', ':ObsidianLinkNew<CR>', { noremap = true, silent = true, desc = 'Obsidian: Link to new note' })
keyset('v', '<leader>ol', ':ObsidianLink<CR>', { noremap = true, silent = true, desc = 'Obsidian: Link selection' })
keyset('v', '<leader>oL', ':ObsidianLinkNew<CR>', { noremap = true, silent = true, desc = 'Obsidian: Link to new note' })

-- Templates and tags
keyset('n', '<leader>oT', ':ObsidianTemplate<CR>', { noremap = true, silent = true, desc = 'Obsidian: Insert template' })
keyset('n', '<leader>og', ':ObsidianTags<CR>', { noremap = true, silent = true, desc = 'Obsidian: Tags picker' })

-- Utility
keyset('n', '<leader>or', ':ObsidianRename<CR>', { noremap = true, silent = true, desc = 'Obsidian: Rename note' })
keyset('n', '<leader>ow', ':ObsidianWorkspace<CR>', { noremap = true, silent = true, desc = 'Obsidian: Switch workspace' })
keyset('n', '<leader>oc', ':ObsidianToggleCheckbox<CR>', { noremap = true, silent = true, desc = 'Obsidian: Toggle checkbox' })


keyset('n', '<C-b>', ":lua require'dap'.toggle_breakpoint()<CR>", { noremap = true, silent = true })
keyset('n', '<F5>', ":lua require'dap'.continue()<CR>", { noremap = true, silent = true })
keyset('n', '<F6>', ":lua require'dap'.step_over()<CR>", { noremap = true, silent = true })
keyset('n', '<F7>', ":lua require'dap'.step_into()<CR>", { noremap = true, silent = true })
keyset('n', '<F8>', ":lua require'dap'.step_out()<CR>", { noremap = true, silent = true })
keyset('n', '<F13>', function() require('smart-splits').move_cursor_left() end)
keyset('n', '<F14>', function() require('smart-splits').move_cursor_down() end)
keyset('n', '<F15>', function() require('smart-splits').move_cursor_up() end)
keyset('n', '<F16>', function() require('smart-splits').move_cursor_right() end)


