/*
   Helper functions that can be built from the core pretty printing library.
 */

{ stdlib, lib, ... }:
with lib; rec {
  lparen = text "(";
  rparen = text ")";
  lbracket = text "[";
  rbracket = text "]";
  lbrace = text "{";
  rbrace = text "}";
  comma = text ",";

  enclose = { left, right, group ? true }: doc:
    let out = sequence [ left doc right ];
    in if group then lib.group out else out;

  parens = { lpad ? null, rpad ? null }: enclose { left = concat lparen lpad; right = concat rpad rparen; };
  brackets = { lpad ? null, rpad ? null }: enclose { left = concat lbracket lpad; right = concat rpad rbracket; };
  braces = { lpad ? null, rpad ? null }: enclose { left = concat lbrace lpad; right = concat rpad rbrace; };

  concatSep = { sep, trailing ? false}: docs:
    if docs == [] then null
    else if stdlib.lists.tail docs == [] then
      if trailing then
        concat (stdlib.lists.head docs) sep
      else
        stdlib.lists.head docs
    else sequence [
      (stdlib.lists.head docs)
      sep
      (concatSep { inherit sep trailing; } (stdlib.lists.tail docs))
    ];

  commaSep = { break ? line, trailing ? false, breakAfter ? true}: concatSep {
      sep = if breakAfter then (concat comma break) else (concat break comma);
      inherit trailing;
    };
}
