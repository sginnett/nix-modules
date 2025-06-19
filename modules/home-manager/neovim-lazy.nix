{ config, pkgs, lib, outputs, ... }:
{
  options.programs.neovim = {
    lazy = {
      enable = lib.mkEnableOption "lazy.nvim integration";
      extraRuntimePath = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
      };
      spec = lib.mkOption {
        description = "lazy.nvim plugin specification";
        type = lib.types.attrsOf (lib.types.submodule ({name, config, ... }: {
          options = {
            shortName = lib.mkOption {
              type = lib.types.str;
              description = "Short name for the plugin, the repo part of the full github identifier";
            };
            fullName = lib.mkOption {
              type = lib.types.str;
              description = "Full name for the plugin, the github <username>/<repo>";
            };
            package = lib.mkOption {
              type = lib.types.package;
              description = "Nix package for the plugin, usually from vimPlugins";
              default = pkgs.vimPlugins.${name};
            };
            enabled = lib.mkOption {
              type = lib.types.nullOr lib.types.bool;
              default = null;
            };

            lazy = lib.mkOption {
              type = lib.types.nullOr lib.types.bool;
              default = null;
            };

            priority = lib.mkOption {
              type = lib.types.nullOr lib.types.int;
              default = null;
            };

            dependencies = lib.mkOption {
              type = lib.types.nullOr (lib.types.listOf (lib.types.attrsOf lib.types.anything));
              default = null;
            };

            opts = lib.mkOption {
              type = lib.types.nullOr (lib.types.oneOf [ lib.types.path lib.types.lines (lib.types.attrsOf lib.types.anything) ]);
              default = null;
            };

            config = lib.mkOption {
              type = lib.types.nullOr (lib.types.oneOf [ lib.types.lines lib.types.path ]);
              default = null;
            };

            event = lib.mkOption {
              type = lib.types.nullOr (lib.types.oneOf [ lib.types.str (lib.types.listOf lib.types.str) ]);
              default = null;
            };

            cmd = lib.mkOption {
              type = lib.types.nullOr (lib.types.oneOf [ lib.types.str (lib.types.listOf lib.types.str) ]);
              default = null;
            };

            ft = lib.mkOption {
              type = lib.types.nullOr (lib.types.oneOf [ lib.types.str (lib.types.listOf lib.types.str) ]);
              default = null;
            };

            keys = lib.mkOption {
              type = lib.types.nullOr (lib.types.listOf (lib.types.oneOf [ lib.types.str (lib.types.listOf lib.types.str) ]));
              default = null;
            };

            lazySpec = lib.mkOption {
              description = "The full lazy.nvim spec for this plugin, computed from other fields. Set this to override.";
              type = lib.types.lines;
            };
          };

          config.shortName = lib.mkDefault config.package.src.repo;
          config.fullName = lib.mkDefault (config.package.src.owner + "/" + config.shortName);
          config.lazySpec = let
            toLua = lib.generators.toLua { multiline = true; };
          in (lib.mkMerge [
            (lib.mkBefore "    {")
            (lib.mkBefore "      ${ toLua config.fullName },")
            (lib.mkIf (config.enabled != null) "      enabled = ${ toLua config.enabled },")
            (lib.mkIf (config.lazy != null) "      lazy = ${ toLua config.lazy },")
            (lib.mkIf (config.priority != null) "      priority = ${ toLua config.priority },")
            (lib.mkIf (config.enabled != null) "      enabled = ${ toLua config.enabled },")
            (lib.mkIf (config.event != null) "      event = ${ toLua config.event },")
            (lib.mkIf (config.cmd != null) "      cmd = ${ toLua config.cmd },")
            (lib.mkIf (config.ft != null) "      ft = ${ toLua config.ft },")
            (lib.mkIf (config.keys != null) "      keys = ${ toLua config.keys },")
            (lib.mkIf (config.opts != null) (
              let
                opts = if (lib.isPath config.opts)
                then builtins.readFile config.opts
                else if (lib.isString config.opts)
                then config.opts
                else toLua config.opts;
              in "      opts = ${ lib.strings.trim (outputs.lib.strings.indent "      " opts) },"
            ))
            (lib.mkIf (config.config != null) (
              let
                opts = if (lib.isPath config.config)
                then builtins.readFile config.config
                else if (lib.isString config.config)
                then config.config
                else toLua config.config;
              in "      config = ${ lib.strings.trim (outputs.lib.strings.indent "      " opts) },"
            ))
            (lib.mkIf (config.dependencies != null) (
              let
                deps = lib.map (dep: toLua dep.fullName) config.dependencies;
              in "      dependencies = { ${lib.concatStringsSep ", " deps} },"
            ))
            (lib.mkAfter "    }")
          ]);
        }));
      };
    };
    lazy-spec = lib.mkOption {
      type = lib.types.lines;
    };
    plugins-package = lib.mkOption {
      type = lib.types.package;
    };
  };


  config.programs.neovim.plugins = lib.mkIf config.programs.neovim.lazy.enable [ pkgs.vimPlugins.lazy-nvim ];

  config.programs.neovim.lazy-spec = lib.mkIf config.programs.neovim.lazy.enable (
    "{\n" + (lib.concatStringsSep ",\n" (lib.mapAttrsToList (name: spec: spec.lazySpec) config.programs.neovim.lazy.spec)) + "\n  }"
  );

  config.programs.neovim.plugins-package = lib.mkIf config.programs.neovim.lazy.enable (
    pkgs.linkFarm "lazy-nvim-plugins" (
      lib.mapAttrsToList (name: spec: { 
        name = spec.shortName;
        path = spec.package;
      }) config.programs.neovim.lazy.spec
    )
  );

  config.programs.neovim.extraLuaConfig = ''
    -------- lazy.nvim -----------
    require("lazy").setup{
      defaults = {
        lazy = true,  -- all plugins are lazy-loaded by default
      },
      -- Let nix manage downloading the plugins, keep lazy.nvim from doing so
      dev = {
        path = "${config.programs.neovim.plugins-package}",
        patterns = { "" },
        fallback = false,

      },
      performance = {
        rtp = {
          paths = ${ lib.generators.toLua { multiline = true; } config.programs.neovim.lazy.extraRuntimePath },
        },
      },
      spec = ${config.programs.neovim.lazy-spec},
    }
  '';
}
