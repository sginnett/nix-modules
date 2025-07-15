{ lib, outputs, ... }:
with outputs.lib.lua; {
  config.programs.neovim.lazy.spec = {
    nvim-surround = {
      opts  = {
        keymaps = {
          insert = false;
          insert_line = false;
          normal = false;
          normal_cur = false;
          normal_line = false;
          normal_cur_line = false;
          visual = false;
          visual_line = false;
          delete = false;
          change = false;
          change_line = false;
        };
      };
      keys = let
        getMode = name:
          if lib.strings.hasPrefix "visual" name then "x"
          else if lib.strings.hasPrefix "insert" name then "i"
          else "n";
        mkLhs = name: "<Plug>(nvim-surround-${name})";
      in lib.map (name:
        mkLuaTable [ (mkLhs name) ] { mode = getMode name; }
      ) [
        "normal"
        "change"
        "delete"
        "visual"
        "insert"
        "normal-cur"
        "normal-cur-line"
        "normal-line"
        "change-line"
        "visual-line"
        "insert-line"
      ];
    };
  };
}
