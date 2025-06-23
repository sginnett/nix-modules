{ stdlib, ... }:
let
  core = import ./core.nix { inherit stdlib; };
  helpers = import ./helpers.nix { inherit stdlib; lib = core; };
  json = import ./json.nix { inherit stdlib; lib = core // helpers; };
in core // helpers // json
