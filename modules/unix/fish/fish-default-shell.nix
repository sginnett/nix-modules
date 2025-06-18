{ lib, outputs, config, pkgs, ... }:
{
  options = {
    programs.fish.defaultShell = lib.mkEnableOption "Use Fish as the default interactive shell";
  };

  config = lib.mkIf config.programs.fish.defaultShell {
    programs.fish = {
      enable = true;
      useBabelfish = true;
    };

    # From nixos manual for fish shell: keep system shell as bash for POSIX compilance, but automatically
    # switch to fish when starting an interactive shell.
    programs.bash.interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };
}
