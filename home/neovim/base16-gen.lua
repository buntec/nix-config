-- Simple base16 colorscheme generator using the oklch color space.
--
-- Run this file from neovim using `luafile %`. Requires mini.base16 and mini.colors!

-- Simple string interpolation.
--
-- Example template: "${name} is ${value}"
--
---@param str string template string
---@param table table key value pairs to replace in the string
local function template(str, table)
  return (
    str:gsub("($%b{})", function(w)
      return vim.tbl_get(table, unpack(vim.split(w:sub(3, -2), ".", { plain = true }))) or w
    end)
  )
end

local function write(str, fileName)
  print("[write] extra/" .. fileName)
  vim.fn.mkdir(vim.fs.dirname("extras/" .. fileName), "p")
  local file = assert(io.open("extras/" .. fileName, "w"))
  file:write(str)
  file:close()
end

-- mini.colors gives us conversion from oklch to hex
local mc = require("mini.colors")

-- dark

local c0 = 4.5
local c1 = 5.5
local l0 = 20.0
local dl = 10.0
local h0 = 220.0
local l1 = 80.0
local h1 = 10.0
local dh = 30.0

local palette_dark = {
  base00 = mc.convert({ l = l0 + 0 * dl, c = c0, h = h0 }, "hex"), -- default background
  base01 = mc.convert({ l = l0 + 1 * dl, c = c0, h = h0 }, "hex"), -- lighter background (status bars)
  base02 = mc.convert({ l = l0 + 2 * dl, c = c0, h = h0 }, "hex"), -- selection background
  base03 = mc.convert({ l = l0 + 3 * dl, c = c0, h = h0 }, "hex"), -- comments, invisibles, line highlighting
  base04 = mc.convert({ l = l0 + 4 * dl, c = c0, h = h0 }, "hex"), -- dark foreground (status bars)
  base05 = mc.convert({ l = l0 + 5 * dl, c = c0, h = h0 }, "hex"), -- default foreground, caret, delimiters, operators
  base06 = mc.convert({ l = l0 + 6 * dl, c = c0, h = h0 }, "hex"), -- light foreground
  base07 = mc.convert({ l = l0 + 7 * dl, c = c0, h = h0 }, "hex"), -- the lightest foreground

  base08 = mc.convert({ l = l1, c = c1, h = h1 + 0 * dh }, "hex"), -- variables, tags
  base09 = mc.convert({ l = l1, c = c1, h = h1 + 1 * dh }, "hex"), -- integers, booleans, constants,...
  base0A = mc.convert({ l = l1, c = c1, h = h1 + 2 * dh }, "hex"), -- classes, search text background
  base0B = mc.convert({ l = l1, c = c1, h = h1 + 3 * dh }, "hex"), -- strings, inherited classes, diff inserted
  base0C = mc.convert({ l = l1, c = c1, h = h1 + 4 * dh }, "hex"), -- support, regex, escape characters
  base0D = mc.convert({ l = l1, c = c1, h = h1 + 5 * dh }, "hex"), -- functions, methods, ...
  base0E = mc.convert({ l = l1, c = c1, h = h1 + 6 * dh }, "hex"), -- keywords, storaged, diff changed, ...
  base0F = mc.convert({ l = l1, c = c1, h = h1 + 7 * dh }, "hex"), -- deprecated, opening/closing tags, ...
}

-- light

c0 = 2.0
c1 = 5.5
l0 = 99.0
dl = -10.0
l1 = 55.0

local palette_light = {
  base00 = mc.convert({ l = l0 + 0 * dl, c = c0, h = h0 }, "hex"), -- default background
  base01 = mc.convert({ l = l0 + 1 * dl, c = c0, h = h0 }, "hex"), -- lighter background (status bars)
  base02 = mc.convert({ l = l0 + 2 * dl, c = c0, h = h0 }, "hex"), -- selection background
  base03 = mc.convert({ l = l0 + 3 * dl, c = c0, h = h0 }, "hex"), -- comments, invisibles, line highlighting
  base04 = mc.convert({ l = l0 + 4 * dl, c = c0, h = h0 }, "hex"), -- dark foreground (status bars)
  base05 = mc.convert({ l = l0 + 5 * dl, c = c0, h = h0 }, "hex"), -- default foreground, caret, delimiters, operators
  base06 = mc.convert({ l = l0 + 6 * dl, c = c0, h = h0 }, "hex"), -- light foreground
  base07 = mc.convert({ l = l0 + 7 * dl, c = c0, h = h0 }, "hex"), -- the lightest foreground

  base08 = mc.convert({ l = l1, c = c1, h = h1 + 0 * dh }, "hex"), -- variables, tags
  base09 = mc.convert({ l = l1, c = c1, h = h1 + 1 * dh }, "hex"), -- integers, booleans, constants,...
  base0A = mc.convert({ l = l1, c = c1, h = h1 + 2 * dh }, "hex"), -- classes, search text background
  base0B = mc.convert({ l = l1, c = c1, h = h1 + 3 * dh }, "hex"), -- strings, inherited classes, diff inserted
  base0C = mc.convert({ l = l1, c = c1, h = h1 + 4 * dh }, "hex"), -- support, regex, escape characters
  base0D = mc.convert({ l = l1, c = c1, h = h1 + 5 * dh }, "hex"), -- functions, methods, ...
  base0E = mc.convert({ l = l1, c = c1, h = h1 + 6 * dh }, "hex"), -- keywords, storaged, diff changed, ...
  base0F = mc.convert({ l = l1, c = c1, h = h1 + 7 * dh }, "hex"), -- deprecated, opening/closing tags, ...
}

local yaml_template = [[
system: "base16"
name: "Kauz"
author: "buntec"
variant: "${variant}"
palette:
  base00: "${base00}"
  base01: "${base01}"
  base02: "${base02}"
  base03: "${base03}"
  base04: "${base04}"
  base05: "${base05}"
  base06: "${base06}"
  base07: "${base07}"
  base08: "${base08}"
  base09: "${base09}"
  base0A: "${base0A}"
  base0B: "${base0B}"
  base0C: "${base0C}"
  base0D: "${base0D}"
  base0E: "${base0E}"
  base0F: "${base0F}"

]]

write(template(yaml_template, vim.tbl_extend("error", palette_dark, { variant = "dark" })), "kauz-dark.yml")
write(template(yaml_template, vim.tbl_extend("error", palette_light, { variant = "light" })), "kauz-light.yml")

require("mini.base16").setup({
  palette = palette_light,
})
