{
  config.programs.neovim.lazy.spec = {
    nvim-surround = {
      opts  = {
        keymaps = {
          insert = "<C-g>x";
          insert_line = "<C-g>X";
          normal = "yx";
          normal_cur = "yxx";
          normal_line = "yX";
          normal_cur_line = "yXX";
          visual = "gS";
          delete = "dx";
          change = "cx";
          change_line = "cX";
        };
      };
      event = "UiEnter";
    };
  };
}
