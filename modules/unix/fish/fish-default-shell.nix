{ lib, outputs, config, pkgs, ... }:
{
  # TODO: Uncomment once flake module tracking is fixed
  # module dependencies
  /*
  imports = [ ../platform.nix ];
  */
  options = {
    programs.fish.defaultShell = lib.mkEnableOption "Use Fish as the default interactive shell";
  };

  config.programs.bash = lib.mkIf config.programs.fish.defaultShell (lib.mkMerge [
    {
      # From nixos manual for fish shell: keep system shell as bash for POSIX compilance, but automatically
      # switch to fish when starting an interactive shell.
      interactiveShellInit = let
        # This test checks if the parent of the current shell is fish. It is different on Linux and macOS since
        # the macOS version of ps uses bsd style options.
        # TODO: it would be nice if `nix develop` and `nix-shell` could auto switcht to fish as well.
        teststr = if config.platform.isLinux
                  then ''[[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]''
                  else ''[[ (! $(ps -o comm= -p $PPID) == *"fish") && -z ''${BASH_EXECUTION_STRING} ]]'';
      in ''
        if ${teststr}
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
        fi
      '';
    }
    (lib.mkIf config.platform.isDarwin  {
      # On Mac we need to enable bash installed by nix
      # Note: need to run 'chsh -s /run/current-system/sw/bin/bash' to set this as the default shell
      enable = true;
    })
  ]);
}
