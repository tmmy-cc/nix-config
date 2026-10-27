{
  hostHome,
  dockerPublicKeysDirectory,
  forwardedPorts,
  dockerStateDirectory,
  dockerDiskSizeMiB,
}:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  hostPkgs = config.virtualisation.host.pkgs;
  localPackages = import ../../pkgs/all-packages.nix {
    pkgs = hostPkgs;
    vzvmBase = hostPkgs.vzvm;
    inherit dockerStateDirectory dockerDiskSizeMiB;
  };
  portName = port: "docker-forward-${toString port}";
in
{
  virtualisation.docker.enable = true;
  users.users.docker = {
    isNormalUser = true;
    extraGroups = [ "docker" ];
  };
  fileSystems."/var/lib/docker" = {
    device = "/dev/vdc";
    fsType = "ext4";
    autoFormat = true;
  };
  virtualisation.sharedDirectories = {
    dockerkeys = {
      source = lib.escapeShellArg dockerPublicKeysDirectory;
      target = "/var/dockerkeys";
    };
    home = {
      source = lib.escapeShellArg hostHome;
      target = hostHome;
    };
  };
  virtualisation.vz = {
    package = localPackages.vzvm-docker;
    forwardPorts = map (port: {
      host.address = "127.0.0.1";
      host.port = port;
      guest.port = port;
    }) forwardedPorts;
  };
  systemd.sockets = lib.listToAttrs (
    map (
      port:
      lib.nameValuePair (portName port) {
        wantedBy = [ "sockets.target" ];
        socketConfig.ListenStream = "vsock::${toString port}";
      }
    ) forwardedPorts
  );
  systemd.services =
    {
      docker.unitConfig.RequiresMountsFor = [
        "/var/lib/docker"
        hostHome
      ];
      copy-builder-keys = {
        requires = [ "var-dockerkeys.mount" ];
        after = [ "var-dockerkeys.mount" ];
        script = lib.mkAfter ''
          install -m 0444 -o root -g root /var/dockerkeys/docker_ed25519.pub /run/builder-keys/docker_ed25519.pub
        '';
      };
    }
    // lib.listToAttrs (
      map (
        port:
        lib.nameValuePair (portName port) {
          serviceConfig.ExecStart = "${pkgs.systemd}/lib/systemd/systemd-socket-proxyd 127.0.0.1:${toString port}";
        }
      ) forwardedPorts
    );
}
