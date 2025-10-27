{ config, pkgs, lib, ... }:
{
  options = {
    development.lilypond.enable = lib.mkEnableOption "LilyPond";
  };

  # Fix fontconfig errors with lilypond
  config.environment.systemPackages = lib.mkIf config.development.lilypond.enable
    (with pkgs; let
      lilyFontsConf = writeText "fonts.conf" ''
        <?xml version='1.0'?>
        <!DOCTYPE fontconfig SYSTEM 'urn:fontconfig:fonts.dtd'>
        <fontconfig>
          <dir>${dejavu_fonts.minimal}</dir>
          <!-- <cachedir prefix="xdg">fontconfig</cachedir> -->
          <cachedir>~/.cache/fontconfig</cachedir>
        </fontconfig>
      '';
      lilypondPatched = pkgs.lilypond.overrideAttrs (oldAttrs: {
        postInstall = ''
          for f in "$out/bin/"*; do
              # Override default argv[0] setting so LilyPond can find
              # its Scheme libraries.
              wrapProgram "$f" --set GUILE_AUTO_COMPILE 0 \
                               --set PATH "${ghostscript}/bin" \
                               --set FONTCONFIG_FILE "${lilyFontsConf}" \
                               --argv0 "$f"
          done
        '';
      });
  in [
    lilypondPatched
  ]);
}
