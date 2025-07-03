local M = {}

function M.get_hex_colors()
  local configuration = vim.fn['gruvbox_material#get_configuration']()
  local palette = vim.deepcopy(vim.fn['gruvbox_material#get_palette'](configuration.background, configuration.foreground, configuration.colors_override))
  palette.none = nil
  local colors = {}
  local index = 1
  for name, color in pairs(palette) do
    colors[index] = color[1]
    index = index + 1
  end
  return colors
end

return M
