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

local config_path = vim.fn.stdpath('config')
package.path = config_path .. "/?.lua;" .. config_path .. "/?/init.lua;" .. config_path .. "/plugins/?.lua;" .. package.path

vim.g.mapleader = " "
function _G.check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

vim.opt.clipboard = "unnamedplus"
vim.g['suda_smart_edit'] = 1
vim.g['suda#nopass'] = 1
vim.g['suda#prompt']='pw:'

require("lazy").setup({
	"lambdalisue/suda.vim",
    {'hrsh7th/nvim-cmp',dependencies={'L3MON4D3/LuaSnip'}},
    'williamboman/mason.nvim',
    "williamboman/mason-lspconfig.nvim",
	"doums/darcula",
    "windwp/nvim-autopairs",
	"tpope/vim-fugitive",
    "preservim/nerdtree",
    "onsails/lspkind.nvim",
    {'neovim/nvim-lspconfig',dependencies={'hrsh7th/cmp-nvim-lsp'}},
   'Vigemus/iron.nvim',
    'mhinz/vim-startify',
{
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    requires = { {"nvim-lua/plenary.nvim"} }
},
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
    'MunifTanjim/prettier.nvim',
    {
    'nvim-telescope/telescope.nvim',
      dependencies = { 'nvim-lua/plenary.nvim' ,'BurntSushi/ripgrep'}
    },
    'nvim-treesitter/nvim-treesitter',
  'VonHeikemen/lsp-zero.nvim',
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
  dependencies = { 'nvim-tree/nvim-web-devicons' }
},
{
 "folke/trouble.nvim",
 dependencies = { "nvim-tree/nvim-web-devicons" },
 opts = {
  -- your configuration comes here
  -- or leave it empty to use the default settings
  -- refer to the configuration section below
 },
}
})

--Loading my personal settings
require('plugins/debug')
require('plugins/remap') -- personal keymappings
require('plugins/treesitter')
require('plugins/prettier')
require('plugins/lsp_zero')
require('plugins/comments') -- gcc gb
require('plugins/lualine') -- status line
require('plugins/iron') -- repl plugin
require('plugins/harpoon') -- repl plugin

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
vim.opt.smartcase = true
