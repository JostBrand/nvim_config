return {
    'mrjones2014/smart-splits.nvim',
    config = function()
        require('smart-splits').setup({
            -- Enable tmux integration for seamless navigation
            ignored_filetypes = { 'nofile', 'quickfix', 'qf', 'prompt' },
            ignored_buftypes = { 'nofile' },
        })
    end,
}
