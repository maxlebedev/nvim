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

local plugins = {
  'mbbill/undotree',

  {
    "hedyhli/outline.nvim", -- unfinished config
    lazy = true,
    cmd = { "Outline", "OutlineOpen" },
    opts = {
      -- Your setup opts here
      auto_jump= true,
      keymaps= {
        fold = 'j',
        unfold = ';',
      }
    },
  },
  -- 'simrat39/symbols-outline.nvim',
  -- {'michaelb/sniprun', run = 'sh ./install.sh'},
  -- 'metakirby5/codi.vim',


  -- 'Vigemus/iron.nvim',

  -- 'rebelot/kanagawa.nvim', { 'dracula/vim', lazy = false, },
  -- 'nvim-tree/nvim-tree.lua',
  'nvim-tree/nvim-web-devicons',
  'nvim-lualine/lualine.nvim',

  'nvim-treesitter/nvim-treesitter',
  -- 'vim-test/vim-test',
  { -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      numhl = false,
      signcolumn = false,
    },
  },
  {
    'projekt0n/caret.nvim', config = function() vim.cmd.colorscheme 'caret' end, },
  -- 'savq/melange-nvim', config = function() vim.cmd.colorscheme 'melange' end, },
  -- { 'jacoborus/tender.vim', config = function() vim.cmd.colorscheme 'tender' end, },
  -- { 'ellisonleao/gruvbox.nvim', config = function() vim.cmd.colorscheme 'gruvbox' end },
  -- { 'bluz71/vim-moonfly-colors', config = function() vim.cmd.colorscheme 'moonfly' end, },

  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    main = "ibl",
    opts = {
      indent = {
        char = {"┊"},
        -- highlight = { "Label" },
      },
      scope = {
        enabled = false,
        show_start = false,
        show_end = false,
      },

      -- ibl.opts.config.indent.char '┊'
      -- show_trailing_blankline_indent = false,
      --ibl.config.blankline.indent = false,
    },
  },
  'tpope/vim-fugitive',
  'tpope/vim-commentary',
  'tpope/vim-obsession',

  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  },


  -- rust babyyyyyyy
  'mfussenegger/nvim-dap',
  'rcarriga/nvim-dap-ui',
  'simrat39/rust-tools.nvim',

  -- completion
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-nvim-lsp',
  { "williamboman/mason.nvim", opts = {} },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Additional lua configuration, makes nvim stuff amazing!
      { 'folke/neodev.nvim', opts = {} },
    },
  },
  "williamboman/mason-lspconfig.nvim",
  "glepnir/lspsaga.nvim",
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.0',
    dependencies = { {'nvim-lua/plenary.nvim'} }
  },
  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
  },
  { 'folke/which-key.nvim', opts = {} },
  {
    'vidocqh/data-viewer.nvim',
    opts = {},
    dependencies = {
      "nvim-lua/plenary.nvim",
      "kkharji/sqlite.lua", -- Optional, sqlite support
    }
  },
  {
    'stevearc/oil.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  'chentoast/marks.nvim',
  'edluffy/hologram.nvim',
}


local opts = {}

require("lazy").setup(plugins, opts)

require('hologram').setup{
    auto_display = true -- WIP automatic markdown image display, may be prone to breaking
}

-- require("plugins.telescope")
require("plugins.mason")
require("plugins.nvim-treesitter")
require("plugins.lualine")
require("plugins.nvim-cmp")
require("plugins.mason-lspconfig")
require("plugins.nvim-lspconfig")
require("plugins.data-viewer")
require("plugins.marks")
-- require("plugins.codi")
-- require("plugins.sniprun")
-- require("plugins.undotree")
-- require("plugins.iron")
