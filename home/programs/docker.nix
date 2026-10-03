{ lib, pkgs, ... }:
{
  home.packages = [
    pkgs.docker-client
    pkgs.docker-compose
    pkgs.dive
  ] ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [ pkgs.colima ];

  home.file.".colima/_templates/default.yaml" = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    text = ''
      runtime: docker
      vmType: vz
      rosetta: true
      mountType: virtiofs
      cpu: 4
      memory: 4
      disk: 100
    '';
  };
}
