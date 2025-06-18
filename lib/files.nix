{lib, ...}:
{
  readModuleDir = (path:
    let files = lib.fileset.toList (lib.fileset.fileFilter (file: (file.hasExt "nix")) path);
    in lib.listToAttrs (lib.map (path: {
      name = lib.removeSuffix ".nix" (builtins.baseNameOf path);
      value = import path;
    }) files));

  readConfigDir = (path:
    let files = lib.fileset.toList (lib.fileset.fileFilter (file: file.name == "configuration.nix") path);
    in lib.listToAttrs (lib.map (file: {
      name = builtins.baseNameOf (builtins.dirOf file);
      value = file;
    }) files));
}
