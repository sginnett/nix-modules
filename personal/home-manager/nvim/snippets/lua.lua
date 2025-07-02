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

local function comma_sep_continue(args, parent, old_state, user_args)
  if #args[1] == 1 and args[1][1] == "" then
    return sn(nil, {t("")})
  else
    return sn(nil, {
      n(1, ", ", ""),
      i(1, ""),
      d(2, comma_sep_continue, {1}, {})
    })
  end
end

local function comma_sep(index)
  return sn(index, {
    i(1, ""),
    d(2, comma_sep_continue, {1}, {})
  })
end

local function any_def()
  return {
    i(1, ""),
    t(" = "),
    i(2, "")
  }
end

local function fn_def()
  return fmta([[
      function<><>(<>)
        <>
      end
    ]],
    {
      n(1, " ", ""),
      i(1, ""),
      comma_sep(2),
      i(3, "--[[body]]")
    }
  )
end

local function local_def()
  return {
    t("local "),
    c(1, {
      sn(nil, any_def()),
      sn(nil, fn_def())
    })
  }
end

local function merge_tables(a, b)
  local result = {}
  for _, v in pairs(a) do
    table.insert(result, v)
  end
  for _, v in pairs(b) do
    table.insert(result, v)
  end
  return result
end

local function local_fn()
  local nodes = {
    t("local ")
  }
  return merge_tables(nodes, fn_def())
end

local function for_loop()
  return fmta([[
    for <> in <> do
      <>
    end
  ]], {
    comma_sep(1),
    i(2, ""),
    i(3)
  })
end

local function else_expr()
  return fmta([[
    else
      <>
  ]], { i(1, "") })
end

local function elif_expr()
  return fmta([[
     elseif <> then
       <>
  ]], { i(1, ""), i(2, "") })
end

local function if_continue(args, parent, old_state, user_args)
  return sn(nil, {
    c(1, {
      t(""),
      merge_tables(elif_expr(), {
        t({"", ""}),
        d(3, if_continue, {}, {})
      }),
      merge_tables(else_expr(), {
        t({"", ""}),
      })
    })
  })
end

local function if_expr()
  return fmta([[
    if <> then
      <>
    <>end
  ]], {
    i(1, ""),
    i(2, ""),
    d(3, if_continue, {}, {})
  })
end

local function return_expr()
  return {
    t("return "),
    comma_sep(1)
  }
end

return {
  s({ trig = ";le", snippetType = "autosnippet", wordTrig = false }, local_def()),
  s({ trig = ";fn", snippetType = "autosnippet", wordTrig = false }, fn_def()),
  s({ trig = ";lf", snippetType = "autosnippet", wordTrig = false }, local_fn()),
  s({ trig = ";if", snippetType = "autosnippet", wordTrig = false }, if_expr()),
  s({ trig = ";el", snippetType = "autosnippet", wordTrig = false }, else_expr()),
  s({ trig = ";ei", snippetType = "autosnippet", wordTrig = false }, elif_expr()),
  s({ trig = ";fo", snippetType = "autosnippet", wordTrig = false }, for_loop()),
  s({ trig = ";re", snippetType = "autosnippet", wordTrig = false }, return_expr()),
}

