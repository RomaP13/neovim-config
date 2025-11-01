require("config.options")
require("config.keymaps")
require("config.autocmds")
require("core.lsp")
require("core.lazy")
local theme = require("core.theme")

theme.load_saved_colorscheme()
