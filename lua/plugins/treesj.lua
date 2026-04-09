return {
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    keys = {
        { '<leader>sj', function() require('treesj').toggle() end, desc = 'TreeSJ: toggle split/join' },
        { '<leader>sJ', function() require('treesj').join() end, desc = 'TreeSJ: join node' },
        { '<leader>sS', function() require('treesj').split() end, desc = 'TreeSJ: split node' },
    },
    opts = {
        use_default_keymaps = false,
        max_join_length = 120,
    },
}
