{ outputs, ... }: {
  nixosModules = {};
  darwinModules = {};
  unixModules = outputs.lib.files.readModuleDir ./unix;
  homeManagerModules = outputs.lib.files.readModuleDir ./home-manager;
}
