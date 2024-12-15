{ config, lib, pkgs, ... }:

let
  podmanPackage = pkgs.podman;

  # Provides a fake "docker" binary mapping to podman
  dockerCompat = pkgs.runCommand "${podmanPackage.pname}-docker-compat-${podmanPackage.version}"
    {
      outputs = [ "out" "man" ];
      inherit (podmanPackage) meta;
      preferLocalBuild = true;
    } ''
    mkdir -p $out/bin
    ln -s ${podmanPackage}/bin/podman $out/bin/docker

    mkdir -p $man/share/man/man1
    for f in ${podmanPackage.man}/share/man/man1/*; do
      basename=$(basename $f | sed s/podman/docker/g)
      ln -s $f $man/share/man/man1/$basename
    done
  '';
in
{
  home.packages = with pkgs; [
    podmanPackage
    dockerCompat
    qemu
    #podman-compose
    docker-compose
    vfkit
    dive # look into docker image layers
    podman-tui
  ];
}
