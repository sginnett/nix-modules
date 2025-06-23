{ lib, strings, ... }:
{
  mkLuaTable = unnamed: named:
    if !(builtins.isList unnamed) then
      throw "Error: unnamed part of lua table must be a list"
    else if !(builtins.isAttrs named) then
      throw "Error: named part of lua table must be an attribute set"
    else
    { _type = "lua-table"; unnamed = unnamed; named = named; };

  mkLuaInline = lib.generators.mkLuaInline;

  mkLuaFunction = name: args: body:
    {
      _type = "lua-function";
      name = name;
      args = args;
      body = body;
    };
}
