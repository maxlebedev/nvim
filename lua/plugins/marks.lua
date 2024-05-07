require("marks").setup()

-- vim.fn.sign_define("MarkSignHL", { texthl = "NONE"})
vim.cmd.highlight({"MarkSignHL", "guibg=#3f4536", "guifg=#61afef"})
vim.cmd.highlight({"MarkSignNumHL", "guibg=NONE", "guifg=NONE"})

