local M = {}

local Terminal = require("toggleterm.terminal").Terminal

local floating = Terminal:new({ count = 9, direction = "float", hidden = true })
local lazygit = Terminal:new({ count = 8, cmd = "lazygit", direction = "float", hidden = true })

function M.toggle_floating()
  floating:toggle()
end

function M.toggle_lazygit()
  lazygit:toggle()
end

return M
