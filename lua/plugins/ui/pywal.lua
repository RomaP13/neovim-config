--TODO: Finish...

local function highlights_base(colors)
  return {
    -- PmenuExtra = { link = "PmenuThumb" },

    BlinkCmpLabel = { fg = colors.foreground, bg = colors.transparent },
    BlinkCmpLabelDeprecated = { fg = colors.color2, bg = colors.transparent },
    BlinkCmpKind = { fg = colors.color4, bg = colors.transparent },
    BlinkCmpMenu = { fg = colors.color2, bg = colors.transparent }, -- or link to PMenu
    BlinkCmpDoc = { link = "NormalFloat" },
    BlinkCmpLabelMatch = { fg = colors.color4, bold = true }, --
    BlinkCmpMenuSelection = { fg = colors.transparent, bg = colors.color2 },
    BlinkCmpScrollBarGutter = { link = "PmenuSbar" },
    BlinkCmpScrollBarThumb = { link = "PmenuThumb" },
    BlinkCmpLabelDescription = { link = "PmenuExtra" },
    BlinkCmpLabelDetail = { link = "PmenuExtra" },
    BlinkCmpSignatureHelpBorder = { link = "FloatBorder" },

    BlinkCmpKindText = { link = "Comment" },
    BlinkCmpKindMethod = { link = "Function" },
    BlinkCmpKindFunction = { link = "Function" },
    BlinkCmpKindConstructor = { link = "Special" },
    BlinkCmpKindField = { link = "Identifier" },
    BlinkCmpKindVariable = { link = "Identifier" },
    BlinkCmpKindClass = { link = "Type" },
    BlinkCmpKindInterface = { link = "Type" },
    BlinkCmpKindModule = { link = "Include" },
    BlinkCmpKindProperty = { link = "Identifier" },
    BlinkCmpKindUnit = { link = "Structure" },
    BlinkCmpKindValue = { link = "Number" },
    BlinkCmpKindEnum = { link = "Type" },
    BlinkCmpKindKeyword = { link = "Keyword" },
    BlinkCmpKindSnippet = { link = "Special" },
    BlinkCmpKindColor = { link = "Special" },
    BlinkCmpKindFile = { link = "Directory" },
    BlinkCmpKindReference = { link = "Special" },
    BlinkCmpKindFolder = { link = "Directory" },
    BlinkCmpKindEnumMember = { link = "Constant" },
    BlinkCmpKindConstant = { link = "Constant" },
    BlinkCmpKindStruct = { link = "Structure" },
    BlinkCmpKindEvent = { link = "Special" },
    BlinkCmpKindOperator = { link = "Operator" },
    BlinkCmpKindTypeParameter = { link = "Type" },
    BlinkCmpKindCopilot = { fg = colors.color6 },

    -- Global borders
    -- FloatBorder = { fg = colors.color5, bg = colors.transparent },

    -- Blink completion borders
    BlinkCmpMenuBorder = { link = "FloatBorder" },
    BlinkCmpDocBorder = { link = "FloatBorder" },
    -- BlinkCmpSignatureHelpBorder = { fg = colors.color5, bg = colors.transparent },

    -- 3. LSP Kind Icons & Text (Linked to standard Pywal-supported groups)
  }
end

local function highlight_all(colors)
  local base_highlights = highlights_base(colors)
  for group, properties in pairs(base_highlights) do
    vim.api.nvim_set_hl(0, group, properties)
  end
end

return {
  "uZer/pywal16.nvim",
  enabled = false,
  lazy = true,
  priority = 1000,
  config = function()
    local pywal16 = require("pywal16")
    pywal16.setup()

    vim.cmd.colorscheme("pywal16")

    local colors = require("pywal16.core").get_colors()
    highlight_all(colors)
  end,
}
