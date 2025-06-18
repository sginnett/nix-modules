{ config, lib, ...}:
{
  /* Note: nixpkgs issue #340361 causes this to fail when using flakes
     Can't properly track dependencies of modules
  imports = [
    outputs.nixosModules.fish-functions
  ]; */

  options = {
    programs.fish.defaultPrompt = lib.mkEnableOption "Default fish prompt";
  };

  config = lib.mkIf config.programs.fish.defaultPrompt {
    programs.fish.functions = {
      fish_prompt = ''
        set -l last_status $status
        set -l status_str
        if test $last_status -ne 0
          set status_str (set_color red)" [$last_status]"(set_color normal)
        end
        set -l prompt_end (set_color cyan)">"(set_color normal)
        set -l prompt_git (fish_git_prompt)

        string join "" -- (prompt_login) ":" (set_color green)(prompt_pwd)(set_color normal) $prompt_git $status_str $prompt_end
      '';

      fish_right_prompt = ''
        set -l dur_ms $CMD_DURATION
        set -l dur_s (math -s 0 "$dur_ms / 1000")
        set -l dur_m 0
        set -l dur_h 0
        set -l dur_d 0
        set -l dur_str
        if test $dur_s -ge 10
          if test $dur_s -ge 60
            set dur_m (math -s 0 "$dur_s / 60")
            set dur_s (math "$dur_s % 60")
            if test $dur_m -ge 60
              set dur_h (math -s 0 "$dur_m / 60")
              set dur_h (math "$dur_m % 60")
              if test $dur_h -ge 24
                set dur_d (math -s 0 "$dur_h / 24")
                set dur_h (math "$dur_h % 24")
                set dur_str $dur_d"d "$dur_h"h "$dur_m"m "$dur_s"s"
              else
                set sur_str $dur_h"h "$dur_m"m "$dur_s"s"
              end
            else
              set dur_str $dur_m"m "$dur_s"s"
            end
          else
            set dur_str $dur_s"s"
          end
          set dur_str "(took $dur_str) " 
        end
        string join "" -- (set_color green) $dur_str (set_color yellow)(date +"[%r]"(set_color normal))
      '';
    };
  };
}
