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
vim.g['suda_smart_edit'] = 1
vim.g['suda#nopass'] = 1
vim.g['suda#prompt']='pw:'

require("lazy").setup({
	"lambdalisue/suda.vim",
    'hrsh7th/nvim-cmp',
	"doums/darcula",
    "windwp/nvim-autopairs",
	"tpope/vim-fugitive",
    "preservim/nerdtree",
    "onsails/lspkind.nvim",
    'neovim/nvim-lspconfig',
   'Vigemus/iron.nvim',
    'mhinz/vim-startify',
    "folke/neodev.nvim",
    "numToStr/Comment.nvim",
    "ryanoasis/vim-devicons",
    'mbbill/undotree',
    "nvim-lua/plenary.nvim",
    "mfussenegger/nvim-dap",
{ 'rose-pine/neovim', name = 'rose-pine' },
    "mfussenegger/nvim-dap-python",
	"rcarriga/nvim-dap-ui",
    "ThePrimeagen/harpoon",
    "preservim/tagbar",
    'jose-elias-alvarez/null-ls.nvim',
    'MunifTanjim/prettier.nvim',
    {
    'nvim-telescope/telescope.nvim',
      dependencies = { 'nvim-lua/plenary.nvim' }
    },

        'nvim-treesitter/nvim-treesitter',
{
  'VonHeikemen/lsp-zero.nvim'},
  {
    "kiyoon/jupynium.nvim",
    build = "pip3 install --user .",
    -- build = "conda run --no-capture-output -n jupynium pip install .",
    -- enabled = vim.fn.isdirectory(vim.fn.expand "~/miniconda3/envs/jupynium"),
  },
{
	"Pocco81/true-zen.nvim",
	config = function()
		 require("true-zen").setup {
			-- your config goes here
		 }
	end,
},
{
  'nvim-lualine/lualine.nvim',
  requires = { 'nvim-tree/nvim-web-devicons', opt = true }
},
})


require('plugins/debug')
require('plugins/remap')
require('plugins/treesitter')
require('plugins/prettier')
require('plugins/lsp_zero')
require('plugins/comments')
require('plugins/lualine')
require('plugins/iron')

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
