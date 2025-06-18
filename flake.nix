{
  description = "Sam's Nix Modules";

  inputs = {
    nixpkgs.url = "github:/nixos/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager}@inputs: let
    inherit (self) outputs;
  in {
    lib = import ./lib { lib = nixpkgs.lib; };
    nixosModules = nixpkgs.lib.mergeAttrs (outputs.lib.files.readModuleDir ./modules/unix) (outputs.lib.files.readModuleDir ./modules/nixos);
    nixosConfigurations = nixpkgs.lib.mapAttrs (name: config:
      nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs outputs; };
        modules = [
          config
        ];
      }
    ) (outputs.lib.files.readConfigDir ./nixos);
  };
}
