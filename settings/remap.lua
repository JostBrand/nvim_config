local keyset = vim.keymap.set
keyset('i', 'qw', '<Esc>', {noremap = true, silent = true})

-- Visual mode mapping for indenting using Tab and shift tab
keyset('v', '<Tab>', '>gv', {noremap = true, silent = true})
keyset('v', '<S-Tab>', '<gv', {noremap = true, silent = true})

-- Map <leader>n to NERDTreeFocus
keyset('n', '<leader>n', ':NERDTreeToggle<CR>', {noremap = true, silent = true})

keyset('n', '<leader>t', ':TagbarToggle<CR>', {noremap = true, silent = true})



-- Lsp keybindings
keyset('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', {noremap = true, silent = true})
keyset('n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>', {noremap = true, silent = true})
keyset('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', {noremap = true, silent = true})
keyset('n', 'gs', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', {noremap = true, silent = true})
keyset('n', '<leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', {noremap = true, silent = true})

local builtin = require('telescope.builtin')
keyset('n', '<C-f>',function () builtin.find_files({hidden=true}) end,{})
keyset('n', '<leader>fg', builtin.live_grep, {})
keyset('n', '<leader>fb', builtin.buffers, {})
keyset('n', '<leader>fh', builtin.help_tags, {})

keyset('v','J',":m '>+1<CR>gv=gv") -- shift lines in visual
keyset('v','K',":m '<-2<CR>gv=gv")

keyset('n','<C-d>',"<C-d>zz") -- keep jumps centered
keyset('n','<C-u>',"<C-u>zz")

keyset('n','n',"nzzzn")
keyset('n','N',"Nzzzn")

vim.g.undotree_SetFocusWhenToggle = 1
keyset('n', '<leader>u', vim.cmd.UndotreeToggle)

--smart toggle nerdtree so it looks for git or goes into current dir of open buffer
vim.api.nvim_set_keymap('n', '<C-n>', ':lua require("plugins/nerdtree").nerdtree_smart_toggle()<CR>', { noremap = true, silent = true })


vim.cmd [[
function! PythonifyList()
    :s/^\(.*\)$/["\1"]/
    :s/[ ,]\+/", "/g
endfunction
]]

-- Map this function to a key for convenience, let's say <Leader>p
vim.api.nvim_set_keymap('n', '<Leader>br', ':call PythonifyList()<CR>', { noremap = true, silent = true })



vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end,
    { desc = "Open harpoon window" })
vim.keymap.set("n", "<leader>a", function() harpoon:list():append() end)

-- vim.keymap.set("n", "<C-1>", function() harpoon:list():select(1) end)
-- vim.keymap.set("n", "<C-2>", function() harpoon:list():select(2) end)
-- vim.keymap.set("n", "<C-3>", function() harpoon:list():select(3) end)
-- vim.keymap.set("n", "<C-4>", function() harpoon:list():select(4) end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)



-- Define the keybindings for debugging
vim.keymap.set('n', '<C-b>', ":lua require'dap'.toggle_breakpoint()<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<F5>', ":lua require'dap'.continue()<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<F6>', ":lua require'dap'.step_over()<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<F7>', ":lua require'dap'.step_into()<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<F8>', ":lua require'dap'.step_out()<CR>", { noremap = true, silent = true })


-- iron also has a list of commands, see :h iron-commands for all available commands
vim.keymap.set('n', '<space>rs', '<cmd>IronRepl<cr>')
vim.keymap.set('n', '<space>rr', '<cmd>IronRestart<cr>')
vim.keymap.set('n', '<space>rf', '<cmd>IronFocus<cr>')
vim.keymap.set('n', '<space>rh', '<cmd>IronHide<cr>')


