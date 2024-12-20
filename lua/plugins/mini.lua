return {
    {
        'echasnovski/mini.nvim',
        version = false,
        dependencies = {
            { 'echasnovski/mini.ai', version = false },
            { 'echasnovski/mini.surround', version = false },
            { 'echasnovski/mini.files', version = false },
            { 'echasnovski/mini.clue', version = false },
        },
        config = function()
            require("mini.ai").setup()
            require("mini.files").setup()
            require("mini.surround").setup()
            local clue = require("mini.clue")
            clue.setup({
            triggers = {
                {mode ="n", keys = "<leader>"},
                    { mode = 'n', keys = 'g' },
    { mode = 'x', keys = 'g' },
            },  clues = {
                -- Enhance this by adding descriptions for <Leader> mapping groups
                clue.gen_clues.builtin_completion(),
                clue.gen_clues.g(),
                clue.gen_clues.marks(),
                clue.gen_clues.registers(),
                clue.gen_clues.windows(),
                clue.gen_clues.z(),
            }})

        end
    }
}
