{ config, pkgs, lib, outputs, ... }:
{
  options.programs.neovim = {
    lazy = {
      enable = lib.mkEnableOption "lazy.nvim integration";
      order = lib.mkOption {
        type = lib.types.int;
        default = 600;
        description = "Order in which to load the lazy.nvim configuration, relative to other Neovim configuration options (lib.mkOrder)";
      };
      specFilename = lib.mkOption {
        type = lib.types.str;
        default = "lazy-spec";
        description = "Filename (without extension) to write the lazy.nvim spec to, relative to the Neovim config directory (usually ~/.config/nvim/lua/)";
      };
      pluginConfigDir = lib.mkOption {
        type = lib.types.str;
        default = "plugins";
        description = "Directory to place plugin specs in, relative to ~/.config/nvim/lua";
      };
      extraRuntimePath = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
      };
      spec = lib.mkOption {
        description = "lazy.nvim plugin specification";
        type = lib.types.attrsOf (lib.types.submodule ({name, config, ... }: {
          options = {
            requiresNodeJs = lib.mkOption {
              type = lib.types.bool;
              description = "Plugin requires Node Js";
              default = false;
            };
            shortName = lib.mkOption {
              type = lib.types.str;
              description = "Short name for the plugin, the repo part of the full github identifier";
            };
            fullName = lib.mkOption {
              type = lib.types.str;
              description = "Full name for the plugin, the github <username>/<repo>";
            };
            fileName = lib.mkOption {
              type = lib.types.str;
              description = "File name (without extension) to place the plugin spec in, relative to the pluginConfigDir";
              default = name;
            };
            package = lib.mkOption {
              type = lib.types.package;
              description = "Nix package for the plugin, usually from vimPlugins";
              default = pkgs.vimPlugins.${name};
            };
            main = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = "Main module for the plugin, if not the default";
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
              type = lib.types.nullOr (lib.types.oneOf [ lib.types.lines lib.types.path (lib.types.attrsOf lib.types.anything) ]);
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
              type = lib.types.anything;
              default = null;
            };

            lazySpec = lib.mkOption {
              description = "The full lazy.nvim spec for this plugin, computed from other fields. Set this to override.";
              type = lib.types.anything;
            };
          };

          config.shortName = lib.mkDefault config.package.src.repo;
          config.fullName = lib.mkDefault (config.package.src.owner + "/" + config.shortName);
          config.lazySpec =
	    lib.filterAttrs (name: val: val != null) {
	      inherit (config) lazy opts cmd event ft keys enabled priority main;
	      dependencies = if config.dependencies == null then null else lib.map (dep: dep.fullName) config.dependencies;
	      config = if builtins.isString config.config then outputs.lib.lua.mkLuaInline config.config else config.config;
	    };
	}));
      };
    };
    lazy-spec = lib.mkOption {
      type = lib.types.listOf lib.types.anything;
    };
    plugins-package = lib.mkOption {
      type = lib.types.package;
    };
  };


  config.programs.neovim.plugins = lib.mkIf config.programs.neovim.lazy.enable [ pkgs.vimPlugins.lazy-nvim ];

  config.programs.neovim.lazy-spec = (lib.mapAttrsToList (name: spec: outputs.lib.lua.mkLuaTable [ spec.fullName ] spec.lazySpec) config.programs.neovim.lazy.spec);

  config.programs.neovim.plugins-package = lib.mkIf config.programs.neovim.lazy.enable (
    pkgs.linkFarm "lazy-nvim-plugins" (
      lib.mapAttrsToList (name: spec: {
        name = spec.shortName;
        path = spec.package;
      }) config.programs.neovim.lazy.spec
    )
  );

  config.programs.neovim.withNodeJs = lib.mkIf (
    config.programs.neovim.lazy.enable
    && (lib.any (t: t) (lib.mapAttrsToList (name: spec: spec.requiresNodeJs) config.programs.neovim.lazy.spec
  ))) true;

  config.xdg.configFile = lib.mkIf config.programs.neovim.lazy.enable (lib.mkMerge [
    (lib.mapAttrs' (name: spec: {
      name = "nvim/lua/${config.programs.neovim.lazy.pluginConfigDir}/${spec.fileName}.lua";
      value.text =
        (with outputs.lib.pretty; pretty 80 (sequence [
          (text "-------- lazy.nvim plugin spec for ${name} -----------")
          hardline
          (text "-- This file was generated by home-manager. Do not edit!")
          hardline
          (text "return ") (toLuaDoc {} (outputs.lib.lua.mkLuaTable [ spec.fullName ] spec.lazySpec))
          hardline
        ]));
    }) config.programs.neovim.lazy.spec)
    {
      "nvim/lua/${config.programs.neovim.lazy.specFilename}.lua".text = let
        modulePath = spec: "${config.programs.neovim.lazy.pluginConfigDir}" + "." + spec.fileName;
      in (with outputs.lib.pretty; pretty 80 (sequence [
          (text ''
            ------------- lazy.nvim spec ------------
            -- This file was generated by home-manager. Do not edit!
            local function loadspec(pname, modname)
              local status, spec = pcall(require, modname)
              if status then
                return spec
              else
                vim.notify("Failed to load lazy.nvim spec for " .. pname .. ": " .. spec, vim.log.levels.ERROR)
                -- If the spec fails to load, disable the plugin to load the rest of the config
                return { pname, enabled = false }
              end
            end
          '')
          hardline
          (text "local specs = ") (toLuaDoc {} (
            lib.mapAttrsToList (name: spec: outputs.lib.lua.mkLuaInline ("loadspec('" + spec.fullName + "', '" + modulePath spec + "')"))
              config.programs.neovim.lazy.spec
          ))
          hardline
          (text "return specs")
        ]));
    }
  ]);

  config.programs.neovim.extraLuaConfig = let
    lazyConfig = {
      defaults = {
        lazy = true;
      };

      dev = {
        path = "${config.programs.neovim.plugins-package}";
        patterns = [ "" ];
        fallback = false;
      };

      performance = {
        rtp = {
          paths = config.programs.neovim.lazy.extraRuntimePath;
        };
      };

      spec = outputs.lib.lua.mkLuaInline "require('${config.programs.neovim.lazy.specFilename}')";
    };
    in lib.mkIf (config.programs.neovim.lazy.enable) (lib.mkOrder config.programs.neovim.options.order (with outputs.lib.pretty; pretty 80 (
      sequence [
        (text "-------- lazy.nvim -----------")
        hardline
        (text "local function lazy()")
        (nest 2 (sequence [
          hardline
          (text "require(\"lazy\").setup ")
          (toLuaDoc {} lazyConfig)
        ]))
        hardline
        (text "end")
        hardline
        (text ''
          -- Catch and report errors in case lazy.nvim fails to load
          local status, err = pcall(lazy)
          if not status then
            vim.notify("Failed to initialize lazy.nvim: " .. err, vim.log.levels.ERROR)
          end
        '')
        hardline
      ]
    )));
}
