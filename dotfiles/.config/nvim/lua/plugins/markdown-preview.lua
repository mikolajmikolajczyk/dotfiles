return {
  {
    "iamcco/markdown-preview.nvim",
    config = function()
      vim.cmd([[do FileType]])

      vim.g.mkdp_browserfunc = "OpenWithGio"

      -- Zdefiniuj funkcję Vimscript, która użyje 'gio open'
      vim.cmd([[
        function! OpenWithGio(url)
          call jobstart(['gio', 'open', a:url], {'detach': v:true})
        endfunction
      ]])
    end,
  },
}
