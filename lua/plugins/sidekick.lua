return {
    'folke/sidekick.nvim',
    event = 'VeryLazy',
    dependencies = {
        'zbirenbaum/copilot.lua',
        'folke/snacks.nvim',
        'nvim-lua/plenary.nvim',
    },
    keys = {
        { '<leader>ak', function() require('sidekick.cli').toggle() end, desc = 'Sidekick: toggle CLI' },
        { '<leader>aK', function() require('sidekick.cli').focus() end, desc = 'Sidekick: focus CLI' },
        { '<leader>as', function() require('sidekick.cli').select() end, desc = 'Sidekick: select CLI' },
        { '<leader>ap', function() require('sidekick.cli').prompt() end, mode = { 'n', 'x' }, desc = 'Sidekick: prompt' },
        { '<leader>af', function() require('sidekick.cli').send({ msg = '{file}' }) end, desc = 'Sidekick: send file' },
        { '<leader>av', function() require('sidekick.cli').send({ msg = '{selection}' }) end, mode = 'x', desc = 'Sidekick: send selection' },
    },
    opts = {
        nes = {
            enabled = false,
        },
        cli = {
            picker = 'snacks',
        },
    },
}
