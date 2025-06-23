{ stdlib, lib, ... }:
with lib; let
  b = builtins;
  hasSimpleType = value:
    b.isString value || b.isInt value || b.isFloat value || b.isBool value || b.isNull value;
in rec
{
  toJsonDoc = json:
    if hasSimpleType json then lib.text (builtins.toJSON json) # These can't have line breaks
    else if builtins.isList json then
      lib.brackets { lpad = lib.nest 2 line; rpad = line; } (lib.nest 2 (lib.commaSep {} (stdlib.map toJsonDoc json)))
    else if builtins.isAttrs json then
      lib.braces { lpad = lib.nest 2 line; rpad = line; }
                 (lib.nest 2
                   (lib.commaSep {} (stdlib.mapAttrsToList (name: value: lib.concat (lib.text (builtins.toJSON name + ": ")) (toJsonDoc value)) json))
                  )
    else throw "Unsupported type for JSON: ${lib.typeOf json}";

  toPrettyJson = width: json: lib.pretty width (toJsonDoc json);
}
