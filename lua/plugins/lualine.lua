require('lualine').setup {
    options = {
      icons_enabled = false,
      theme = 'onedark',
      -- component_separators = '|',
      component_separators = { left = '', right = '' },
      section_separators = '',
      globalstatus = false
    },
  sections = {
    lualine_c = {
      {
        'filename',
        file_status = true, -- displays file status (readonly status, modified status)
        path = 2 -- 0 = just filename, 1 = relative path, 2 = absolute path
      }
    }
  },
  inactive_sections = {
    lualine_c = {
      {
        'filename',
        file_status = true, -- displays file status (readonly status, modified status)
        path = 4 -- 0 = just filename, 1 = relative path, 2 = absolute path
      }
    }
  }
}

