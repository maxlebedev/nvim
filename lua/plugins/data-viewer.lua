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

require('data-viewer').setup {
  opts = config,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "kkharji/sqlite.lua", -- Optional, sqlite support
  }
}
