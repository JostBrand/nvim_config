return {
    "lambdalisue/suda.vim",
    "doums/darcula",
    "tpope/vim-fugitive",
    "tpope/vim-speeddating",
    "ryanoasis/vim-devicons",
    {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("ibl").setup { indent = { char = { "▏" } } }
        end
    },
    'mbbill/undotree',
    "nvim-lua/plenary.nvim",
    { 'rose-pine/neovim', name = 'rose-pine' },
    "preservim/tagbar"
}