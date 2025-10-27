{ lib, config, pkgs, ... }: {
  options = {
    programs.fish.functions = lib.mkOption {
      type = lib.types.attrsOf (lib.types.coercedTo
        lib.types.lines
        (lines: { body = lines; })
        (lib.types.submodule ({config, name, ...}: {
        options = {
          source = lib.mkOption {
            type = lib.types.nullOr lib.types.path;
            default = null;
          };

          name = lib.mkOption {
            type = lib.types.str;
            default = name;
            description = "Name of the function";
          };

          description = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "Description of the function";
          };

          wraps = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "Name of the function this function wraps, used for generating completions";
          };

          body = lib.mkOption {
            type = lib.types.nullOr lib.types.lines;
            default = null;
            description = "Body of the function";
          };

          argumentNames = lib.mkOption {
            type = lib.types.nullOr (lib.types.listOf lib.types.str);
            default = null;
            description = "List of argument names for the function";
          };

          functionDeclaration = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "The function name <args> declaration, automatically generated if not provided";
          };

          fullSource = lib.mkOption {
            type = lib.types.nullOr (
              lib.types.coercedTo
                lib.types.path
                (path: if builtins.isPath path then builtins.readFile path else path)
                lib.types.lines
            );
            default = null;
            description = "Full source code of the function, derived from other options is not overriden";
          };
        };

        config = lib.mkMerge [
          {
            functionDeclaration = "function ${config.name}"
              + (lib.optionalString (config.description != null) " -d '${config.description}'")
              + (lib.optionalString (config.wraps != null) " -w ${config.wraps}")
              + (lib.optionalString (config.argumentNames != null) " -a ${lib.concatStringsSep " " config.argumentNames}");
          }
          {
            fullSource = lib.mkBefore ''${config.functionDeclaration}'';
          }
          {
            fullSource = lib.mkIf (config.source != null) config.source;
          }
          {
            fullSource = lib.mkIf (config.body != null) config.body;
          }
          {
            fullSource = lib.mkAfter ''end'';
          }
        ];
      })));
    };
  };

  config = lib.mkIf (config.programs.fish.enable) {
      environment.systemPackages = let
        fishFunctions = pkgs.linkFarm "system-fish-functions" (lib.mapAttrsToList (name: value: {
            name = "functions/${name}.fish";
            path = pkgs.writeText "fish-function-${name}" value.fullSource;
          }) config.programs.fish.functions);
      in [
        (pkgs.fishPlugins.buildFishPlugin {
          version = "0.0.1";
          pname = "system-fish-functions-plugin";
          src = "${fishFunctions}";
        })
      ];
  };
}
