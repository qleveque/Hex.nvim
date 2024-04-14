local M = {}

M.setup_search = function()
  vim.cmd[[
    nn <buffer> / :HexSearch 
    nn <buffer> ? :HexSearchBack 
  ]]
end

M.setup_ASCII = function(cfg)
  M.setup_search()
  vim.cmd[[
    setl nonu ft=hexASCII noma
    au CursorMoved,CursorMovedI <buffer> lua require'hex.cursor'.on_ASCII_cursor_move()
    au BufEnter <buffer> lua require'hex'.on_ASCII_enter()
    au BufLeave <buffer> lua require'hex'.on_ASCII_leave()
    au WinClosed <buffer> lua require'hex.references'.on_ASCII_close()
    au FileChangedShellPost <buffer> lua require'hex.utils'.bind_scroll_and_cursor()
  ]]
  local buf = vim.api.nvim_get_current_buf()
  local skm = vim.api.nvim_buf_set_keymap
  skm(buf, 'n', cfg.keymaps.replace_ascii,
    ':lua require"hex.utils".replace_in_ASCII()<CR>',
  {})
  skm(buf, 'n', cfg.keymaps.undo_ascii,
    ':lua require"hex.utils".undo_from_ASCII()<CR>',
  {})
  skm(buf, 'n', cfg.keymaps.redo_ascii,
    ':lua require"hex.utils".redo_from_ASCII()<CR>',
  {})
  skm(buf, 'n', cfg.keymaps.run, ':lua require"hex".run()<CR>', {})
end

M.setup_HEX = function(cfg)
  M.setup_search()
  vim.cmd[[
    au CursorMoved,CursorMovedI <buffer> lua require'hex.cursor'.on_HEX_cursor_move()
    au BufEnter <buffer> lua require'hex'.on_HEX_enter()
    au BufLeave <buffer> lua require'hex'.on_HEX_leave()
    au WinClosed <buffer> lua require'hex.references'.on_HEX_close()
    au BufHidden <buffer> lua require'hex.references'.close_ASCII_if_visible()
    au BufWritePost <buffer> lua require'hex'.on_HEX_saved()
    au BufWinEnter <buffer> :HexOpenAscii
  ]]

  local buf = vim.api.nvim_get_current_buf()
  local skm = vim.api.nvim_buf_set_keymap
  skm(buf, 'n', cfg.keymaps.reformat_hex, ':HexReformat<CR>', {})
  skm(buf, 'n', cfg.keymaps.run, ':lua require"hex".run()<CR>', {})

end

return M