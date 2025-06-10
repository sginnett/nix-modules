{
  description = "Sam's Nix Modules";

  inputs = {
    nixpkgs.url = "github:/nixos/nixpkgs/nixos-24.11";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager}: {
    nixosModules = {
      default = ./modules/default.nix;
    };
  };
}
