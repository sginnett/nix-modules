{ lib, ... }:
{
  indent = (prefix: block:
    let
      split = lib.strings.splitString "\n" block;
      indented = lib.map (str: prefix + str) split;
    in lib.concatLines indented
  );
}
