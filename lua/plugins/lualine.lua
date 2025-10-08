require('lualine').setup {
    options = {
      icons_enabled = true,
      theme = 'onedark',
      component_separators = { left = '', right = '' },
      section_separators = { left = '', right = ''},
      globalstatus = true,
    },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {
      {
        'filename',
        file_status = true,
        path = 3
      }
    },
    lualine_x = {'lsp_status'},
    lualine_y = {'filetype', 'location'},
    lualine_z = {
      {
        'tabs',
        show_modified_status = false
      }
    },
  },
}
