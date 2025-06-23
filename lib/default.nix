{lib, ... }:
rec {
  files = import ./files.nix { inherit lib; };
  types = import ./types.nix { inherit lib; };
  strings = import ./strings.nix { inherit lib; };
  lua = import ./lua.nix { inherit lib strings; };
  pretty = import ./pretty { stdlib = lib; inherit lua; };
}
