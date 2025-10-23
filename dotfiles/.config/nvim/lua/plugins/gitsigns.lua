return {
  "lewis6991/gitsigns.nvim",
  opts = {
    current_line_blame = true, -- show blame on current line
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol", -- eol | overlay | right_align
      delay = 300, -- delay in ms before showing blame
      ignore_whitespace = true,
    },
    current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
  },
}
