local ls = require("luasnip")

local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node
local c = ls.choice_node
local extras = require("luasnip.extras")
local n = extras.nonempty
local fmta = require("luasnip.extras.fmt").fmta
local events = require("luasnip.util.events")

local function assignment()
  return fmta([[
    <> = <>;
  ]], {
    i(1, "name"),
    i(2, "value")
  })
end

local function module()
  return fmta([[
    { config, lib, pkgs, ... }:
    {
      imports = [
        <>
      ];

      options = {
        <>
      };

      config = {
        <>
      };
    }
  ]], {
    i(1, ""),
    i(2, ""),
    i(3, ""),
  })
end

local function with()
  return fmta([[
    with <>; <>
  ]], {
    i(1, ""),
    i(2, "")
  })
end

-- For testing
local function snippets()
  return {
    s({ trig = ";as", snippetType = "autosnippet", wordTrig = false }, assignment()),
    s({ trig = ";mo", snippetType = "autosnippet", wordTrig = false }, module()),
    s({ trig = ";wi", snippetType = "autoshippet", wordTrig = false }, with())
  }
end

-- For Testing
-- ls.add_snippets("nix", snippets(), { key = "testing" })

return snippets()
