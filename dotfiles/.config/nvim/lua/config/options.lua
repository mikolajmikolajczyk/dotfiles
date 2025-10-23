-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.ai_cmp = false

vim.filetype.add({
  filename = {
    ["justfile"] = "just",
    ["Justfile"] = "just",
    [".justfile"] = "just",
  },
  extension = {
    just = "just",
    tf = "terraform",
    tfvars = "terraform",
    hcl = "hcl",
    tfstate = "json",
  },
  pattern = {
    [".*/[Jj]ustfile"] = "just",
    [".*%.tfstate"] = "json",
    [".*%.tfstate%.backup"] = "json",
  },
})
