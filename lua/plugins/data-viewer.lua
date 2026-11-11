local config = {
  autoDisplayWhenOpenFile = false,
  maxLineEachTable = 100,
  columnColorEnable = true,
  columnColorRoulette = { -- Highlight groups
    "DataViewerColumn0",
    "DataViewerColumn1",
    "DataViewerColumn2",
  },
  view = {
    float = false, -- False will open in current window
    width = 1, -- Less than 1 means ratio to screen width, valid when float = true
    height = 1, -- Less than 1 means ratio to screen height, valid when float = true
    zindex = 50, -- Valid when float = true
  },
  keymap = {
    quit = "q",
    next_table = "<C-l>",
    prev_table = "<C-h>",
  },
}

local function link_column_colors()
  vim.api.nvim_set_hl(0, "DataViewerColumn0", { link = "Function" })
  vim.api.nvim_set_hl(0, "DataViewerColumn1", { link = "String" })
  vim.api.nvim_set_hl(0, "DataViewerColumn2", { link = "Type" })
end

link_column_colors()
vim.api.nvim_create_autocmd("ColorScheme", { callback = link_column_colors })

require('data-viewer').setup(config)
