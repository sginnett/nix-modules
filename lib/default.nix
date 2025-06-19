{lib, ...}: {
  files = import ./files.nix { inherit lib; };
  types = import ./types.nix { inherit lib; };
  strings = import ./strings.nix { inherit lib; };
}
