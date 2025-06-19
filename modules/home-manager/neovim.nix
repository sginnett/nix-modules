{ config, pkgs, lib, ... }:
{
  options.programs.neovim = {
    lazy.enable = lib.mkEnableOption "lazy.nvim integration";
    options.vim.opt = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      description = "lines of the form vim.opt.<name> = <value> to add to the nvim lua config";
    };

    options.vim.g = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      description = "lines of the form vim.g.<name> = <value> to add to the nvim lua config";
    };
  };

  config.programs.neovim.extraLuaConfig = let
    vim-opt = lib.filter ({value, ...}: value != null) (lib.attrsToList config.programs.neovim.options.vim.opt);
    vim-g   = lib.filter ({value, ...}: value != null) (lib.attrsToList config.programs.neovim.options.vim.g);
    total-len = (lib.lists.length vim-opt) + (lib.lists.length vim-g);
    toLua = lib.generators.toLua { multiline = false; };
  in lib.mkIf (total-len != 0) (lib.strings.concatLines (
    (lib.map ({name, value}: ''vim.opt.${name} = ${toLua value}'') vim-opt)
    ++ (lib.map ({name, value}: ''vim.g.${name} = ${toLua value}'') vim-g)
  ));
}
