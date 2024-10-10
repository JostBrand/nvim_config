local keyset = vim.keymap.set
keyset('i', 'qw', '<Esc>', {noremap = true, silent = true})

-- Visual mode mapping for indenting using Tab and shift tab
keyset('v', '<Tab>', '>gv', {noremap = true, silent = true})
keyset('v', '<S-Tab>', '<gv', {noremap = true, silent = true})


keyset('n', '<leader>t', ':TagbarToggle<CR>', {noremap = true, silent = true})

-- Lsp keybindings
keyset('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', {noremap = true, silent = true})
keyset('n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>', {noremap = true, silent = true})
keyset('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', {noremap = true, silent = true})
keyset('n', 'gs', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', {noremap = true, silent = true})
keyset('n', '<leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', {noremap = true, silent = true})

local builtin = require('telescope.builtin')
keyset('n', '<C-f>',function () builtin.find_files({hidden=true}) end,{})
keyset('n', '<leader>fc',function () builtin.find_files({
    hidden = true,
    search_dirs={"~/.config","~/.ssh","~/Dokumente","~/Downloads","~/bkp/Sources"}  }) end,{})
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

    vim.cmd [[
    function! PythonifyList()
    :s/^\(.*\)$/["\1"]/
    :s/[ ,]\+/", "/g
    endfunction
    ]]

    -- Map this function to a key for convenience, let's say <Leader>p
    vim.api.nvim_set_keymap('n', '<Leader>br', ':call PythonifyList()<CR>', { noremap = true, silent = true })


    keyset('n', '<C-b>', ":lua require'dap'.toggle_breakpoint()<CR>", { noremap = true, silent = true })
    keyset('n', '<F5>', ":lua require'dap'.continue()<CR>", { noremap = true, silent = true })
    keyset('n', '<F6>', ":lua require'dap'.step_over()<CR>", { noremap = true, silent = true })
    keyset('n', '<F7>', ":lua require'dap'.step_into()<CR>", { noremap = true, silent = true })
    keyset('n', '<F8>', ":lua require'dap'.step_out()<CR>", { noremap = true, silent = true })

    function get_visual_selection()
        vim.cmd('exec "norm! vip\\<esc>"')
        local start_row= vim.fn.getpos("'<")[2]
        local end_row = vim.fn.getpos("'>")[2]
        vim.fn.MoltenEvaluateRange(start_row,end_row)
    end

    vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>lua get_visual_selection()<CR>', {noremap = true})
    keyset("n", "<leader>mi", ":MoltenInit<CR>", { silent = true, desc = "Initialize the plugin" })
    keyset("n", "<leader>e", ":MoltenEvaluateOperator<CR>",    { silent = true, desc = "run operator selection" })
    keyset("v", "<leader>ff", ":<C-u>MoltenEvaluateVisual<CR>gv",    { silent = true, desc = "evaluate visual selection" })
    keyset("n", "<leader>rr", ":MoltenReevaluateCell<CR>",{ silent = true, desc = "re-evaluate cell" })
    keyset("n", "<leader>rd", ":MoltenDelete<CR>",    { silent = true, desc = "molten delete cell" })
    keyset("n", "<leader>oh", ":MoltenHideOutput<CR>",    { silent = true, desc = "hide output" })
    keyset("n", "<leader>os", ":noautocmd MoltenEnterOutput<CR>",    { silent = true, desc = "show/enter output" })


    local truezen = require("true-zen")
    keyset('n', '<leader>zf', truezen.focus, { noremap = true })
    keyset('n', '<leader>zm', truezen.minimalist, { noremap = true })
    keyset('n', '<leader>za', truezen.ataraxis, { noremap = true })


