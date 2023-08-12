local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }) 
end
vim.opt.rtp:prepend(lazypath)

-- In Ihrer init.lua
local config_path = vim.fn.stdpath('config')
package.path = config_path .. "/?.lua;" .. config_path .. "/?/init.lua;" .. config_path .. "/plugins/?.lua;" .. package.path

vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct
-- Autocomplete
function _G.check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}

vim.opt.clipboard = "unnamedplus"
vim.g.suda_smart_edit = 1
vim.g.suda_nopass = 1

require("lazy").setup({
	"lambdalisue/suda.vim",
	"doums/darcula",
"windwp/nvim-autopairs",
	"tpope/vim-fugitive",
    "preservim/nerdtree",
    'neovim/nvim-lspconfig',
    "folke/neodev.nvim",
    "numToStr/Comment.nvim",
    {'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring'}},
    "ryanoasis/vim-devicons",
'mbbill/undotree',
    "nvim-lua/plenary.nvim",
    "mfussenegger/nvim-dap",
{ 'rose-pine/neovim', name = 'rose-pine' },
    "mfussenegger/nvim-dap-python",
	"rcarriga/nvim-dap-ui",
    'jose-elias-alvarez/null-ls.nvim',
    'MunifTanjim/prettier.nvim',
{
    "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
},
{
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
},
{
  'VonHeikemen/lsp-zero.nvim',
  branch = 'v2.x',
  dependencies = {
    -- LSP Support
    {'neovim/nvim-lspconfig'},             -- Required
    {'williamboman/mason.nvim'},           -- Optional
    {'williamboman/mason-lspconfig.nvim'}, -- Optional

    -- Autocompletion
    {'hrsh7th/nvim-cmp'},     -- Required
    {'hrsh7th/cmp-nvim-lsp'}, -- Required
    {'L3MON4D3/LuaSnip'},     -- Required
  }
}
})


require('plugins/debug')
require('plugins/remap')
require('plugins/treesitter')
require('plugins/prettier')
require('plugins/lsp_zero')
require('plugins/comments')



vim.api.nvim_exec([[
    function! IsGitRepository()
        return isdirectory('.git') || filereadable('.git')
    endfunction

    augroup MyNERDTree
        autocmd!
        autocmd StdinReadPre * let s:std_in=1
        autocmd VimEnter * if argc() == 0 && !exists('s:std_in') && v:this_session == '' && IsGitRepository() | NERDTree | endif
    augroup END
]], false)

vim.cmd('colorscheme rose-pine')


-- General options
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50
vim.opt.colorcolumn = "80"
