{ pkgs, ... }:
pkgs.writeScriptBin "git-recent" (builtins.readFile ./git-recent.fish)
