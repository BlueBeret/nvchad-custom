vim.cmd([[
  augroup MyAutoCmds
    autocmd!
    autocmd VimEnter * lua require("custom.lurifosterm").initPresenceLoop()
    autocmd VimLeave * lua require("custom.lurifosterm").stopPresenceLoop()
  augroup END
]])
