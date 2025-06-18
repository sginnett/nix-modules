{ lib, ... }: {
  email = lib.types.addCheck lib.types.str (email:
    let
      emailRegex = "^[a-zA-Z0–9._%+-]+@[a-zA-Z0–9.-]+\.[a-zA-Z]{2,}$";
      match = builtins.match emailRegex email;
    in (match != null) && (builtins.length match == 0)
  ) // {
    name = "emailAddress";
    description = "an email address";
  };
}
