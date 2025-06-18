{lib, ...}: {
  files = import ./files.nix { inherit lib; };
}
