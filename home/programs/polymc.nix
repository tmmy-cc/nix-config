{ config, lib, pkgs, ... }:

let
  cfg = config.programs.polymc;
  polymc = if cfg.javaPackage == null then
    pkgs.polymc
  else
    let
      javaPath = "${cfg.javaPackage}/bin/java";
      migrateJavaPath = pkgs.writeShellScript "polymc-migrate-java-path" ''
        dataBase="''${XDG_DATA_HOME:-$HOME/.local/share}"

        for dataDir in "$dataBase/PolyMC" "$dataBase/polymc"; do
          if [ -d "$dataDir" ]; then
            ${lib.getExe pkgs.findutils} "$dataDir" -type f \( -name polymc.cfg -o -name instance.cfg \) -exec \
              ${lib.getExe pkgs.gnused} -i 's|^JavaPath=.*$|JavaPath=${javaPath}|' {} + || true
          fi
        done
      '';
      polymcBase = pkgs.polymc.override {
        jdks = [ cfg.javaPackage ];
      };
    in
    pkgs.symlinkJoin {
      name = "polymc";
      paths = [ polymcBase ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        rm "$out/bin/polymc"
        makeWrapper ${polymcBase}/bin/polymc "$out/bin/polymc" \
          --run ${migrateJavaPath}
      '';
    };
in
{
  options.programs.polymc.javaPackage = lib.mkOption {
    type = lib.types.nullOr lib.types.package;
    default = null;
    description = "Java package used by PolyMC.";
  };

  config = {
    home.packages = [
      polymc
    ] ++ lib.optional (cfg.javaPackage != null) cfg.javaPackage;

    home.sessionVariables = lib.mkIf (cfg.javaPackage != null) {
      JAVA_HOME = "${cfg.javaPackage}/lib/openjdk";
    };
  };
}
