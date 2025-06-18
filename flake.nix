{
  description = "Sam's Nix Modules";

  inputs = {
    nixpkgs.url = "github:/nixos/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, nix-darwin }@inputs: let
    inherit (self) outputs;
  in {
    # Helper functions
    lib = import ./lib { lib = nixpkgs.lib; };

    # Modules specific to NixOS
    nixosModules = outputs.lib.files.readModuleDir ./modules/nixos;

    # Modules that work equally well on NixOS and nix-darwin
    unixModules = outputs.lib.files.readModuleDir ./modules/unix;

    # Modules that are specific to nix-darwin
    # darwinModules = outputs.lib.files.readModuleDir ./modules/darwin;

    # Home Manager modules
    homeManagerModules = outputs.lib.files.readModuleDir ./modules/home-manager;

    # NixOS Configurations
    nixosConfigurations = nixpkgs.lib.mapAttrs (name: config:
      nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs outputs; };
        modules = [
          config
        ] ++ nixpkgs.lib.mapAttrsToList (name: module: module) outputs.nixosModules
          ++ nixpkgs.lib.mapAttrsToList (name: module: module) outputs.unixModules;
      }
    ) (outputs.lib.files.readConfigDir ./nixos);

    # Darwin Configurations
    darwinConfigurations = nixpkgs.lib.mapAttrs (name: config:  nix-darwin.lib.darwinSystem {
      specialArgs = { inherit inputs outputs; };
      modules = [
        config
        home-manager.darwinModules.home-manager
      ] # ++ nixpkgs.lib.mapAttrsToList (name: module: module) outputs.darwinModules
        ++ nixpkgs.lib.mapAttrsToList (name: module: module) outputs.unixModules;
    }) (outputs.lib.files.readConfigDir ./darwin);
  };
}
