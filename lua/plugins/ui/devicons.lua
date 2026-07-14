return {
  "nvim-tree/nvim-web-devicons",
  init = function()
    local devicons = require("nvim-web-devicons")
    local cache = {}

    local function get_custom_ext(name)
      if not name then
        return nil
      end

      local cached = cache[name]
      if cached ~= nil then
        return cached
      end

      local ext
      if name:find("^Dockerfile") then
        ext = "Dockerfile"
      elseif name:find("^%.env") then
        ext = "env"
      elseif name:find("docker%-compose.*%.yml") then
        ext = "docker-compose.yml"
      end

      cache[name] = ext or false
      return ext
    end

    local get_icon = devicons.get_icon
    ---@diagnostic disable-next-line: duplicate-set-field
    devicons.get_icon = function(name, ext, opts)
      return get_icon(name, get_custom_ext(name) or ext, opts)
    end

    local get_icon_colors = devicons.get_icon_colors
    ---@diagnostic disable-next-line: duplicate-set-field
    devicons.get_icon_colors = function(name, ext, opts)
      return get_icon_colors(name, get_custom_ext(name) or ext, opts)
    end
  end,
  opts = {},
}
