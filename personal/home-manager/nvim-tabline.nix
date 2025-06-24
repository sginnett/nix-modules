{ config, lib, pkgs, options, ... }:
{
  config.programs.neovim.lazy.spec = lib.mkIf config.programs.neovim.sginnett.defaults.enable {
    tabby-nvim = {
      opts = {};
      event = "UiEnter";
      keys = [
        [ "<Leader>to" ":tabonly<CR>" ]
        [ "<Leader>ta" ":$tabnew<CR>" ]
        [ "<Leader>tc" ":tabclose<CR>" ]
        [ "<Leader>to" ":tabonly<CR>" ]
        [ "<Leader>tn" ":tabnext<CR>" ]
        [ "<Leader>tp" ":tabprevious<CR>" ]
        [ "<Leader>tmp" ":-tabmove<CR>" ]
        [ "<Leader>tmn" ":+tabmove<CR>" ]
      ];
    };
  };
}
