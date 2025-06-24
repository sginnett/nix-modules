# A pretty-printer for Lua values, including lua-tables
# and functions
{ stdlib, lib, lua }:
with lib; let
  b = builtins;
  mkLuaTable = lua.mkLuaTable;
  hasSimpleType = value:
    b.isString value || b.isInt value || b.isFloat value || b.isBool value || b.isNull value;
  prettyLua = rec {
    toLuaDoc = args: luaVal:
      if hasSimpleType luaVal then lib.text (stdlib.generators.toLua {} luaVal)
      else if b.isList luaVal then
        toLuaDoc args (mkLuaTable luaVal {})
      else if b.isAttrs luaVal then
        if luaVal ? _type then
          if luaVal._type == "lua-table" then luaTableToDoc args luaVal
          else if luaVal._type == "lua-function" then luaFunctionToDoc args luaVal
          else if luaVal._type == "lua-inline" then luaInlineToDoc args luaVal
          else throw "Unsupported special type for Lua: ${luaVal._type}"
        else luaTableToDoc args (mkLuaTable [] luaVal)
      else throw "Unsupported type for Lua: ${stdlib.typeOf luaVal}";

    luaNameBinding = name: if stdlib.strings.match "^[a-zA-Z0-9_]+$" name == null then "[ " + builtins.toJSON name + " ]" else name;

    # TODO: handle [ "name" ] style keys properly
    luaAttrsetBinding = args: name: value:
      concat (lib.text (luaNameBinding name + " = ")) (toLuaDoc args value);

    luaTableToDoc = args: luaTable:
      if  luaTable._type != "lua-table"
      then throw "Error: expected a lua-table"
      else let
        unnamed = luaTable.unnamed;
        named = luaTable.named;
        unnamedSection = commaSep { trailing = false; }
                           (stdlib.map (toLuaDoc args) unnamed);
        mid = if builtins.length unnamed > 0 && builtins.length (stdlib.attrsToList named) > 0
              then (concat comma line) else null;
        namedSection = commaSep { trailing = false; }
                          (stdlib.mapAttrsToList
                            (luaAttrsetBinding args) named);
        in braces { lpad = nest 2 line; rpad = line; }
              (nest 2 (sequence [ unnamedSection mid namedSection ]));

    luaFunctionToDoc = args: luaFunction:
      if luaFunction._type != "lua-function"
      then throw "Error: expected a lua-function"
      else let
        name = luaFunction.name;
        funcArgs = luaFunction.args;
        body = luaFunction.body;
        decl = if name == null then text "function("
               else text ("function " + name + "(");
        args = commaSep { trailing = false; }
                  (stdlib.map (name: text name) funcArgs);
        init = sequence [ decl args (text ")") ];
        mid = nest 2 (concat line (luaBlockToDoc args body));
        end = sequence [ line (text "end") ];
        in group (sequence [ init mid end ]);

    luaBlockToDoc = args: block:
      if b.isList block then
        concatSep { sep = hardline;} (stdlib.map (toLuaDoc args) block)
      else toLuaDoc args block;

    luaInlineToDoc = args: luaInline:
      concatSep { sep = hardline; }
         (stdlib.map text (stdlib.strings.splitString "\n" (stdlib.strings.trim luaInline.expr)));

    prettyLua = width: luaVal: lib.pretty width (toLuaDoc {} luaVal);
  };
in { inherit (prettyLua) toLuaDoc; }
