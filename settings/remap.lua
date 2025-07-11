local keyset = vim.keymap.set
keyset('i', 'qw', '<Esc>', { noremap = true, silent = true })
keyset('i', 'jj', '<Esc>', { noremap = true, silent = true })

-- Visual mode mapping for indenting using Tab and shift tab
keyset('v', '<Tab>', '>gv', { noremap = true, silent = true })
keyset('v', '<S-Tab>', '<gv', { noremap = true, silent = true })


keyset('t', '<leader><Esc>', "<C-\\><C-n><C-w>h", { silent = true })

-- Lsp keybindings
keyset('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })
keyset('n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>', { noremap = true, silent = true })
keyset('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true })
keyset('n', 'gs', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', { noremap = true, silent = true })
keyset('n', '<leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', { noremap = true, silent = true })

keyset('n', '<leader>p', ":pu<CR>")
local builtin = require('telescope.builtin')
keyset('n', '<C-f>', function() builtin.find_files({ hidden = true }) end, {})
keyset('n', '<leader>fc', function()
    builtin.find_files({
        hidden = true,
        search_dirs = { "~/.config", "~/.ssh", "~/Dokumente", "~/Downloads", "~/bkp/Sources" }
    })
end, {})
keyset('n', '<leader>fg', builtin.live_grep, {})
keyset('n', '<leader>fb', builtin.buffers, {})
keyset('n', '<leader>fh', builtin.help_tags, {})
keyset('n', '<leader>fr', builtin.resume, {})
keyset('n', '<leader>ft', builtin.treesitter, {})
keyset('n', '<leader>fs', builtin.grep_string, {})


keyset('n', '<leader>gb', builtin.git_branches, {})
keyset('n', '<leader>gc', builtin.git_commits, {})
keyset('n', '<leader>gs', builtin.git_status, {})

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



-- Map this function to a key for convenience, let's say <Leader>p
keyset('n', '<Leader>br', ':call PythonifyList()<CR>', { noremap = true, silent = true })
keyset('n', '<leader>fm', ':lua vim.lsp.buf.format()<CR>', { noremap = true, silent = true })
keyset('n', '<leader>mf', ':lua MiniFiles.open()<CR>', { noremap = true, silent = true })


--- Obsidian keybindings
keyset('n', '<leader>oo', ':ObsidianQuickSwitch<cr>', { noremap = true, silent = true })


keyset('n', '<C-b>', ":lua require'dap'.toggle_breakpoint()<CR>", { noremap = true, silent = true })
keyset('n', '<F5>', ":lua require'dap'.continue()<CR>", { noremap = true, silent = true })
keyset('n', '<F6>', ":lua require'dap'.step_over()<CR>", { noremap = true, silent = true })
keyset('n', '<F7>', ":lua require'dap'.step_into()<CR>", { noremap = true, silent = true })
keyset('n', '<F8>', ":lua require'dap'.step_out()<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<F13>', require('smart-splits').move_cursor_left)
vim.keymap.set('n', '<F14>', require('smart-splits').move_cursor_down)
vim.keymap.set('n', '<F15>', require('smart-splits').move_cursor_up)
vim.keymap.set('n', '<F16>', require('smart-splits').move_cursor_right)


vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.py" },                     -- Only run for Python files
    callback = function()
        vim.lsp.buf.format({ async = false }) -- Format synchronously
    end,
})
