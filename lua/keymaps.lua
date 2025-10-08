
-- Kinesis Mode
vim.keymap.set({'n', 'v'}, 'j', 'h')
vim.keymap.set({'n', 'v'}, 'k', 'gj')
vim.keymap.set({'n', 'v'}, 'l', 'gk')
vim.keymap.set({'n', 'v'}, ';', 'l')

-- arrows for window mgmt
vim.keymap.set('n', '<Left>', '<c-w>h')
vim.keymap.set('n', '<Down>', '<c-w>j')
vim.keymap.set('n', '<Up>', '<c-w>k')
vim.keymap.set('n', '<Right>', '<c-w>l')

vim.keymap.set('n', '<S-Left>', '<c-w>H')
vim.keymap.set('n', '<S-Down>', '<c-w>J')
vim.keymap.set('n', '<S-Up>', '<c-w>K')
vim.keymap.set('n', '<S-Right>', '<c-w>L')

vim.keymap.set('n', '<leader>j', 'gT')
vim.keymap.set('n', '<leader>;', 'gt')

vim.keymap.set('i', '<S-Tab>', '<C-d>') -- untabs in insert mode

vim.keymap.set('v', '<S-Tab>', '<gv')
vim.keymap.set('v', '<Tab>', '>gv') -- >> with tab in vmode

vim.keymap.set('n', 'U', '<Cmd>redo<Cr>')

vim.keymap.set('n', '<leader><BS>', ':b#<cr>', {desc="Return to prev file"})
-- C-i and C-o navigate the split buffer stack

vim.keymap.set('t', '<ESC>', '<C-\\><C-n>')

-- is this a different goto def than the builtin?
vim.keymap.set('n', 'gD', '<C-w>]', {desc="[G]oto [D]efinition"})

-- vim.keymap.set('i', '<S-Tab>', vim.diagnostic.open_float)

vim.keymap.set('n', 'gF', '<C-w><C-f>', {desc="[G]oto [F]ile in split"})


vim.keymap.set('n', 'gb', ':Git blame<Cr>', {desc="[G]it [b]lame"})
-- probably should live in pluins/undotree
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, {desc="Undotree toggle"})

vim.keymap.set('n', '<leader>t', ':ToggleTerm<CR>')

WinSwap = function()
  local swap_buf = -1 --assuming buf/win numbers are nonnegative
  local swap_win = -1
  return function()
    if swap_buf == -1 then
      swap_buf = vim.api.nvim_get_current_buf()
      swap_win = vim.api.nvim_get_current_win()
      print("SwapBuf set")
    else
      local tmpBuf = vim.api.nvim_get_current_buf()
      vim.api.nvim_set_current_buf(swap_buf)
      vim.api.nvim_win_set_buf(swap_win, tmpBuf)
      swap_buf = -1
      swap_win = -1
      print("SwapBuf unset")
    end
  end
end
vim.keymap.set('n', '<leader>w', WinSwap(), {desc="WinSwap"})

vim.keymap.set('v', "<leader>d", [[:s/\(\w\+\)\.\(\w\+\)/\1["\2"]/g]], {desc='foo.bar to foo["bar"]'})
vim.keymap.set('v', "<leader>a", [[:s/\(\w\+\)\["\(\w\+\)"]/\1.\2/g]], {desc='foo.bar to foo.bar'})

vim.keymap.set('v', "<leader>:", [[:s/\(\w\+\)=/"\1": /g]], {desc='a=b to "a":b'})
vim.keymap.set('v', "<leader>=", [[:s/"\(\w\+\)": \?/\1=/g]], {desc='"a": b to a=b'})

vim.keymap.set('v', "<leader>c", [[:s/_\([a-z]\)/\U\1/g]], {desc='snake_case to camelCase'})
vim.keymap.set('v', "<leader>s", [[:s/\([A-Z]\)/_\l\1/g]], {desc='camelCase to snake_case'})
-- there is also title-case?


vim.keymap.set('n', "<leader>dbg", [[iprint(f"{=}")<ESC>3hi]], {desc='debug print'})

vim.keymap.set('n', "<leader>o", "<cmd>Outline<CR>", {desc="Toggle outline"})
