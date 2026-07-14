vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.path:append("**")

vim.opt.backspace = '2'
vim.opt.laststatus = 2
vim.opt.autowrite = true
vim.opt.autoread = true

vim.o.synmaxcol = 300

-- use spaces for tabs and whatnot (does this work with python?)
-- vim.opt.tabstop = 2
-- vim.opt.shiftwidth = 2
-- vim.opt.shiftround = true
-- vim.opt.expandtab = true

vim.o.swapfile = false
vim.o.wildmenu = true
vim.o.wildmode = "longest:full"
vim.o.list = true
vim.o.listchars = "tab:▸ ,trail:·,nbsp:␣"

--Line numbers
vim.wo.number = false

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
  signs = false,  -- explicit false; omitting it defaults to true → shows built-in E/W/I/H letters
  -- arrows disabled — diagnostics conveyed via underline only. Re-enable by uncommenting.
  --[[
  signs = {
    text = {
      -- https://github.com/neovim/neovim/commit/8122470f8310ae34bcd5e436e8474f9255eb16f2
      [vim.diagnostic.severity.ERROR] = "->",
      [vim.diagnostic.severity.WARN] = "->",
      [vim.diagnostic.severity.INFO] = "->",
      [vim.diagnostic.severity.HINT] = "->",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticError",
      [vim.diagnostic.severity.WARN] = "DiagnosticWarn",
      [vim.diagnostic.severity.INFO] = "DiagnosticInfo",
      [vim.diagnostic.severity.HINT] = "DiagnosticHint",
    }
  }
  --]]
})
vim.opt.signcolumn = "number"
-- vim.cmd.highlight({"DiagnosticError", "cterm=bold", "gui=bold", "guifg=#2a2d25", "guibg=#f18e91"})
-- vim.cmd.highlight({"DiagnosticWarn", "cterm=bold", "gui=bold", "guifg=#2a2d25", "guibg=Orange"})
-- DagnosticSignError for highlighted bg, no "sign" for no bg
-- Dead while `signs = false` (numhl-only signs never render). Kept for re-enabling.
-- vim.fn.sign_define("DiagnosticSignError", { numhl = "DiagnosticError"})
-- vim.fn.sign_define("DiagnosticSignWarn", { numhl = "DiagnosticWarn"})
-- vim.fn.sign_define("DiagnosticSignHint", { numhl = "DiagnosticHint"})
-- vim.fn.sign_define("DiagnosticSignInfo", { numhl = "DiagnosticInfo"})

-- Color the diagnostic underline via `sp` (the squiggle) instead of `fg` (the
-- text), so underlined code keeps its syntax color. Re-applied on ColorScheme
-- because oxocarbon sets these with `fg` and runs `hi clear` when it loads.
local function diagnostic_underline_sp()
  for _, group in ipairs({
    "DiagnosticUnderlineError",
    "DiagnosticUnderlineWarn",
    "DiagnosticUnderlineInfo",
    "DiagnosticUnderlineHint",
  }) do
    local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
    if hl.fg then
      hl.sp = hl.fg
      hl.fg = nil
      vim.api.nvim_set_hl(0, group, hl)
    end
  end
end
vim.api.nvim_create_autocmd("ColorScheme", { callback = diagnostic_underline_sp })
diagnostic_underline_sp()


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

vim.g.undotree_SetFocusWhenToggle = 1

vim.opt.showtabline = 0

vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    vim.opt_local.expandtab = true     -- convert tabs to spaces
    vim.opt_local.shiftwidth = 2       -- indentation size
    vim.opt_local.tabstop = 2          -- how many spaces a tab counts for
    vim.opt_local.softtabstop = 2
  end,
})

vim.api.nvim_create_autocmd("BufWritePost", { pattern = "*.py",
  command = "silent! !ruff check --fix % && ruff format %",
})

vim.opt.timeoutlen = 300
