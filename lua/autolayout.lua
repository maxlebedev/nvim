-- Laptop-screen layout for a 3x2 tab: when the terminal narrows (unplugging the
-- external monitor), restack it into two columns -- L1 C1 L2 C2 on the left,
-- R1 R2 on the right -- and put it back when it widens again. Windows are moved
-- with nvim_win_set_config, not recreated, so buffers/cursors/jumplists survive.
-- Width is the only signal, so dragging nvim between screens behaves the same
-- as plugging/unplugging.
local NARROW_COLS = 180 -- laptop screen is 177; monitors are wider

local saved = {} -- tabpage -> { L1, L2, C1, C2, R1, R2 } while stacked

-- The tab's layout as a list of columns of window ids, or nil if it isn't a
-- plain row of columns.
local function columns(tab)
  local layout = vim.fn.winlayout(vim.api.nvim_tabpage_get_number(tab))
  if layout[1] ~= "row" then return nil end
  local cols = {}
  for _, node in ipairs(layout[2]) do
    if node[1] ~= "col" then return nil end
    local ids = {}
    for _, leaf in ipairs(node[2]) do
      if leaf[1] ~= "leaf" then return nil end
      table.insert(ids, leaf[2])
    end
    table.insert(cols, ids)
  end
  return cols
end

-- win = -1 makes it a top-level split (full height, at the edge).
local function move(win, target, dir)
  vim.api.nvim_win_set_config(win, { win = target, split = dir })
end

local function apply()
  local tab = vim.api.nvim_get_current_tabpage()
  local c = columns(tab)
  if not c then return end
  local narrow = vim.o.columns <= NARROW_COLS

  if narrow and #c == 3 and #c[1] == 2 and #c[2] == 2 and #c[3] == 2 then
    local L1, L2, C1, C2, R1, R2 = c[1][1], c[1][2], c[2][1], c[2][2], c[3][1], c[3][2]
    move(C1, L1, "below")
    move(C2, L2, "below")
    saved[tab] = { L1, L2, C1, C2, R1, R2 }
  elseif not narrow and saved[tab] then
    local L1, L2, C1, C2, R1, R2 = unpack(saved[tab])
    saved[tab] = nil
    -- Layout was rearranged by hand while stacked; leave it alone.
    if not vim.deep_equal(c, { { L1, C1, L2, C2 }, { R1, R2 } }) then return end
    move(C1, -1, "right")
    move(C2, C1, "below")
    move(R1, -1, "right")
    move(R2, R1, "below")
  else
    return
  end
  vim.cmd("wincmd =")
end

-- Synchronous, not debounced: rearranging inside the event means terminal
-- buffers only ever get the final size. A delay lets a redraw resize them to
-- the squeezed 3x2 width first.
vim.api.nvim_create_autocmd({ "VimResized", "TabEnter", "VimEnter", "SessionLoadPost" }, {
  group = vim.api.nvim_create_augroup("autolayout", {}),
  callback = apply,
})
