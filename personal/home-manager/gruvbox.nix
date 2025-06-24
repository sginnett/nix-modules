{ config, lib, pkgs, ... }:
{
  options = {
    gruvbox-hex = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
    };
  };

  config.gruvbox-hex = let
    gruv-txt = builtins.readFile ./gruvbox.txt;
    lines = builtins.map lib.strings.trim (builtins.filter (line: line != "") (lib.lists.drop 2 (lib.splitString "\n" gruv-txt)));
    matches = builtins.map (line: builtins.match "^([[:alnum:]_]+)[[:space:]]+(#[0-9a-fA-F]{6}).*$" line) lines;
    hex = builtins.map (match: {name = builtins.elemAt match 0; value = builtins.elemAt match 1;}) matches;
  in lib.listToAttrs hex;
}
