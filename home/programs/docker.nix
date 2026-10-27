{ lib, pkgs, ... }:
let
  initializeDocker = pkgs.writeShellApplication {
    name = "docker-builder-init";
    runtimeInputs = [ pkgs.docker-client ];
    text = ''
      unset DOCKER_HOST DOCKER_CONTEXT
      if docker context inspect vzvm >/dev/null 2>&1; then
          docker context update vzvm --docker host=ssh://docker-builder
      else
          docker context create vzvm --docker host=ssh://docker-builder
      fi
      docker context use vzvm
    '';
  };
in
{
  home.packages = [
    pkgs.docker-client
    pkgs.docker-compose
    pkgs.dive
  ] ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [ initializeDocker ];
}
