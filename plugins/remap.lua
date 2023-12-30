local keyset = vim.keymap.set
keyset('i', 'qw', '<Esc>', {noremap = true, silent = true})

-- Visual mode mapping for indenting using Tab
keyset('v', '<Tab>', '>gv', {noremap = true, silent = true})

-- Visual mode mapping for un-indenting using Shift-Tab
keyset('v', '<S-Tab>', '<gv', {noremap = true, silent = true})

-- Map <leader>n to NERDTreeFocus
-- keyset('n', '<leader>n', ':NERDTreeFocus<CR>', {noremap = true, silent = true})

-- Map <C-t> to NERDTreeToggle
keyset('n', '<leader>n', ':NERDTreeToggle<CR>', {noremap = true, silent = true})

-- Map <C-f> to NERDTreeFind
keyset('n', '<C-f>', ':NERDTreeFind<CR>', {noremap = true, silent = true})

keyset('n', '<leader>t', ':TagbarToggle<CR>', {noremap = true, silent = true})
-- Coc keybindings
-- Go to definition
keyset('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', {noremap = true, silent = true})

-- Go to references
keyset('n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>', {noremap = true, silent = true})

-- Show hover
keyset('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', {noremap = true, silent = true})

-- Show signature help
keyset('n', 'gs', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', {noremap = true, silent = true})

-- Rename symbol
keyset('n', '<leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', {noremap = true, silent = true})

-- Insert mode mapping for completion
keyset('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true, noremap = true})
keyset('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<S-Tab>"', {expr = true, noremap = true})
keyset('i', '<CR>', 'pumvisible() ? "\\<C-y>" : "\\<C-g>u\\<CR>"', {expr = true, noremap = true})

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
keyset('n', '<leader>u', vim.cmd.UndotreeToggle)

-- zen mode
local truezen = require('true-zen')

keyset('n', '<leader>zn', function()
  local first = 0
  local last = vim.api.nvim_buf_line_count(0)
  truezen.narrow(first, last)
end, { noremap = true })
keyset('v', '<leader>zn', function()
  local first = vim.fn.line('v')
  local last = vim.fn.line('.')
  truezen.narrow(first, last)
end, { noremap = true })
keyset('n', '<leader>zf', truezen.focus, { noremap = true })
keyset('n', '<leader>zm', truezen.minimalist, { noremap = true })
keyset('n', '<leader>za', truezen.ataraxis, { noremap = true })

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
