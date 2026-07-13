return {
  "nvim-web-devicons",
  config = function()
    local devicons = require("nvim-web-devicons")
    local cache = {}

    local function get_custom_ext(name)
      if cache[name] then
        return cache[name]
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
    devicons.get_icon = function(name, ext, opts)
      return get_icon(name, get_custom_ext(name) or ext, opts)
    end

    local get_icon_colors = devicons.get_icon_colors
    devicons.get_icon_colors = function(name, ext, opts)
      return get_icon_colors(name, get_custom_ext(name) or ext, opts)
    end

    -- devicons.setup {
    --   override = {
    --     ["Dockerfile"] = { icon = "", color = "#0db7ed", name = "Dockerfile" },
    --     ["docker-compose.yml"] = { icon = "", color = "#0db7ed", name = "DockerCompose" },
    --     ["env"] = { icon = "", color = "#faf743", name = "DotEnv" }, -- Icon for .env files
    --   },
    -- }
  end,
}
