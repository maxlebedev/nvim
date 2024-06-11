vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.path = "**"

vim.opt.backspace = '2'
vim.opt.laststatus = 2
vim.opt.autowrite = true
vim.opt.autoread = true

-- use spaces for tabs and whatnot (does this work with python?)
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.shiftround = true
vim.opt.expandtab = true

vim.o.swapfile = false
vim.o.wildmenu = true
vim.o.wildmode = "longest:full"
vim.o.list = true
vim.o.listchars = "tab:▸ ,trail:·,nbsp:␣"

--Line numbers
vim.wo.number = true

-- Mouse off
vim.o.mouse = ""
-- vim.o.mousehide = true
vim.o.scrolloff = 8

vim.o.clipboard = 'unnamedplus'
vim.o.breakindent = true
vim.o.undofile = true

-- Search
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true
vim.o.hlsearch = true

-- vim.o.completeopt = 'menuone,noselect'
vim.o.termguicolors = true

vim.o.splitright = true
vim.o.splitbelow = false


vim.api.nvim_command('autocmd VimResized * wincmd =')

-- vim.cmd([[ highlight Search guibg=DimGrey guifg=NONE ]])
vim.cmd.highlight({"Search", "guibg=DimGrey", "guifg=NONE"})


-- vim.cmd.highlight({"DiagnosticSignWarn", "guibg=NONE", "guifg=#61afef"})
--vim.highlight.create('DiagnosticSignWarn', { ctermbg=0, guifg='#61afef', guibg='#31353f' }, false)

vim.diagnostic.config({
  virtual_text = false,
  float = true,
  signs = {
    text = {
      -- https://github.com/neovim/neovim/commit/8122470f8310ae34bcd5e436e8474f9255eb16f2
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = " ",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticError",
      [vim.diagnostic.severity.WARN] = "DiagnosticWarn",
      [vim.diagnostic.severity.INFO] = "DiagnosticInfo",
      [vim.diagnostic.severity.HINT] = "DiagnosticHint",
    }
  }
})
vim.opt.signcolumn = "number"
-- vim.cmd.highlight({"DiagnosticError", "cterm=bold", "gui=bold", "guifg=#2a2d25", "guibg=#f18e91"})
-- vim.cmd.highlight({"DiagnosticWarn", "cterm=bold", "gui=bold", "guifg=#2a2d25", "guibg=Orange"})
-- DagnosticSignError for highlighted bg, no "sign" for no bg
vim.fn.sign_define("DiagnosticSignError", { numhl = "DiagnosticError"})
vim.fn.sign_define("DiagnosticSignWarn", { numhl = "DiagnosticWarn"})
vim.fn.sign_define("DiagnosticSignHint", { numhl = "DiagnosticHint"})
vim.fn.sign_define("DiagnosticSignInfo", { numhl = "DiagnosticInfo"})


-- TODO: error/warn info can be conveyed via color alone
-- git bg too, but they gotta look different. Maybe erros get bg and git gets fg?
-- using red/yellow/green in both cases kinda samey. maybe turn off gitsigns?

vim.api.nvim_command('au FocusGained,BufEnter * :checktime')
local function system(command)
  local file = assert(io.popen(command, 'r'))
  local output = file:read('*all'):gsub("%s+", "")
  file:close()
  return output
end

if vim.fn.executable("python3") > 0 then
  vim.g.python3_host_prog = system("which python3")
end
