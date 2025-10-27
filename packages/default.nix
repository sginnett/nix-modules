{ lib, pkgs, ... }:
{
  git-recent = import ./git-recent.nix { inherit lib pkgs; };
}
