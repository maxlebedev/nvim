-- Laptop-screen layout for a 3x2 tab: when the terminal narrows (unplugging the
-- external monitor), restack it into two columns -- L1 C1 L2 C2 on the left,
-- R1 R2 on the right -- and put it back when it widens again. Windows are moved
-- with nvim_win_set_config, not recreated, so buffers/cursors/jumplists survive.
-- Width is the only signal, so dragging nvim between screens behaves the same
-- as plugging/unplugging.
-- The stacked layout is recognized by shape (4 left, 2 right), not remembered,
-- so it still restores after a restart or session load done on the laptop.
local NARROW_COLS = 180 -- laptop screen is 177; monitors are wider

local pending = {} -- tabpage -> true: restore to 3x2 next time it's current and wide
local was_narrow -- nil until the first event

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

local function apply(ev)
  local narrow = vim.o.columns <= NARROW_COLS
  -- Coming up wide (startup, session load, plugging the monitor in): any tab may
  -- be sitting in the stacked layout, so flag them all. TabEnter restores the rest.
  if not narrow and (was_narrow ~= false or ev.event == "SessionLoadPost") then
    for _, t in ipairs(vim.api.nvim_list_tabpages()) do pending[t] = true end
  end
  was_narrow = narrow

  local tab = vim.api.nvim_get_current_tabpage()
  local c = columns(tab)
  if not c then return end

  if narrow and #c == 3 and #c[1] == 2 and #c[2] == 2 and #c[3] == 2 then
    local L1, L2, C1, C2 = c[1][1], c[1][2], c[2][1], c[2][2]
    move(C1, L1, "below")
    move(C2, L2, "below")
  elseif not narrow and pending[tab] then
    pending[tab] = nil
    if not (#c == 2 and #c[1] == 4 and #c[2] == 2) then return end
    local L1, C1, L2, C2 = unpack(c[1])
    local R1, R2 = unpack(c[2])
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

-- IDEA (parked): generalize past the one 3x2 <-> 4+2 case.
-- Fold: target = floor(vim.o.columns / MIN_COL_WIDTH) columns; merge adjacent
-- columns down to that, interleaving rows so windows keep their row position
-- (4 -> (1+2)(3+4), 3 -> (1+2)(3), 4 -> 3 is (1+2)(3)(4)). Covers widths
-- between laptop and monitor too.
-- Restore is the hard half -- a stacked shape is ambiguous (4+2 could be a
-- folded 2,2,2 or a deliberate 4+2):
--   A. Uniform-grid assumption: k = shortest column's height, any column of
--      m*k windows splits back into m. Stateless, so survives restart/session
--      load (the property the shape-based restore was for). Non-uniform
--      layouts like 1,2,2 just never fold.
--   B. Record the original column counts as metadata (a g: var persists in
--      sessions with 'globals' in sessionoptions). Handles any shape, but
--      winids change across restarts, so it'd key on tab number / buffer
--      names, which can drift.
-- Named layouts (`:Layout save <name>` / `:Layout <name>`) would sit on the
-- same "arrange these windows into this column structure" core.
-- Open question: which layouts besides 3x2 are actually in use? All uniform
-- grids -> A (~30 lines). Uneven ones -> B or named layouts.
