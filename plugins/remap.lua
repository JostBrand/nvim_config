local keyset = vim.keymap.set
vim.keymap.set('i', 'jk', '<Esc>', {noremap = true, silent = true})
vim.keymap.set('i', 'jj', '<Esc>', {noremap = true, silent = true})

-- Visual mode mapping for indenting using Tab
vim.keymap.set('v', '<Tab>', '>gv', {noremap = true, silent = true})

-- Visual mode mapping for un-indenting using Shift-Tab
vim.keymap.set('v', '<S-Tab>', '<gv', {noremap = true, silent = true})

-- Map <leader>n to NERDTreeFocus
vim.keymap.set('n', '<leader>n', ':NERDTreeFocus<CR>', {noremap = true, silent = true})

-- Map <C-t> to NERDTreeToggle
vim.keymap.set('n', '<C-n>', ':NERDTreeToggle<CR>', {noremap = true, silent = true})

-- Map <C-f> to NERDTreeFind
vim.keymap.set('n', '<C-f>', ':NERDTreeFind<CR>', {noremap = true, silent = true})

-- Coc keybindings
-- Go to definition
vim.keymap.set('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', {noremap = true, silent = true})

-- Go to references
vim.keymap.set('n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>', {noremap = true, silent = true})

-- Show hover
vim.keymap.set('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', {noremap = true, silent = true})

-- Show signature help
vim.keymap.set('n', 'gs', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', {noremap = true, silent = true})

-- Rename symbol
vim.keymap.set('n', '<leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', {noremap = true, silent = true})

-- Insert mode mapping for completion
vim.keymap.set('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true, noremap = true})
vim.keymap.set('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<S-Tab>"', {expr = true, noremap = true})
vim.keymap.set('i', '<CR>', 'pumvisible() ? "\\<C-y>" : "\\<C-g>u\\<CR>"', {expr = true, noremap = true})

-- Define the keybindings
vim.keymap.set('n', '<C-b>', ":lua require'dap'.toggle_breakpoint()<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<F5>', ":lua require'dap'.continue()<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<F6>', ":lua require'dap'.step_over()<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<F7>', ":lua require'dap'.step_into()<CR>", { noremap = true, silent = true })
vim.keymap.set('n', '<F8>', ":lua require'dap'.step_out()<CR>", { noremap = true, silent = true })

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-f>',function () builtin.find_files({hidden=true}) end,{})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

vim.keymap.set('v','J',":m '>+1<CR>gv=gv") -- shift lines in visual
vim.keymap.set('v','K',":m '<-2<CR>gv=gv")

vim.keymap.set('n','<C-d>',"<C-d>zz") -- keep jumps centered
vim.keymap.set('n','<C-u>',"<C-u>zz")

vim.keymap.set('n','n',"nzzzn")
vim.keymap.set('n','N',"Nzzzn")
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)

-- zen mode
local truezen = require('true-zen')

vim.keymap.set('n', '<leader>zn', function()
  local first = 0
  local last = vim.api.nvim_buf_line_count(0)
  truezen.narrow(first, last)
end, { noremap = true })
vim.keymap.set('v', '<leader>zn', function()
  local first = vim.fn.line('v')
  local last = vim.fn.line('.')
  truezen.narrow(first, last)
end, { noremap = true })
vim.keymap.set('n', '<leader>zf', truezen.focus, { noremap = true })
vim.keymap.set('n', '<leader>zm', truezen.minimalist, { noremap = true })
vim.keymap.set('n', '<leader>za', truezen.ataraxis, { noremap = true })

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
