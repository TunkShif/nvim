local M = {}

function M.contains(list, item)
  for _, value in ipairs(list) do
    if value == item then
      return true
    end
  end
  return false
end

return M
