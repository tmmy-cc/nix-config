{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nix.linux-builder;
  hostMacOSVersion = cfg.hostMacOSVersion;
  dockerCfg = cfg.docker;
  clientDirectory = "${cfg.workingDirectory}/docker-client";
  publicKeysDirectory = "${cfg.workingDirectory}/docker-public-keys";
  hostHome = config.users.users.${dockerCfg.hostUser}.home;
in
{
  options.nix.linux-builder.hostMacOSVersion = lib.mkOption {
    type = lib.types.str;
    example = "15.7.3";
    description = "Target macOS version used to select the Rosetta-compatible guest kernel.";
  };

  options.nix.linux-builder.docker = {
    hostUser = lib.mkOption {
      type = lib.types.str;
      description = "Mac user who owns the Docker SSH client key and shared home directory.";
    };
    forwardedPorts = lib.mkOption {
      type = lib.types.listOf lib.types.port;
      default = [
        8080
        5432
      ];
      description = "TCP ports forwarded from Mac localhost to Docker-published ports in the guest.";
    };
    diskSizeMiB = lib.mkOption {
      type = lib.types.ints.positive;
      default = 100 * 1024;
      description = "Initial size of the persistent Docker data disk in MiB.";
    };
  };

  config = {
    assertions = [
      {
        assertion = !(builtins.elem 31022 dockerCfg.forwardedPorts);
        message = "Docker forwarded ports must leave port 31022 available for builder SSH.";
      }
    ];
    environment.etc."ssh/vzvm-docker-known-hosts".text = "linux-builder ${
      builtins.readFile cfg.package.nixosConfig.environment.etc."ssh/ssh_host_ed25519_key.pub".source
    }";
    environment.etc."ssh/ssh_config.d/110-docker-builder.conf".text = ''
      Host docker-builder
        HostName 127.0.0.1
        Port 31022
        User docker
        IdentityFile ${clientDirectory}/id_ed25519
        IdentitiesOnly yes
        HostKeyAlias linux-builder
        UserKnownHostsFile /etc/ssh/vzvm-docker-known-hosts
        StrictHostKeyChecking yes
    '';
    system.activationScripts.preActivation.text = ''
      ${pkgs.coreutils}/bin/install -d -m 0755 ${lib.escapeShellArg cfg.workingDirectory} ${lib.escapeShellArg publicKeysDirectory}
      ${pkgs.coreutils}/bin/install -d -m 0700 -o ${lib.escapeShellArg dockerCfg.hostUser} ${lib.escapeShellArg clientDirectory}
      if [ ! -f ${lib.escapeShellArg "${clientDirectory}/id_ed25519"} ]; then
          ${pkgs.openssh}/bin/ssh-keygen -q -t ed25519 -N "" -f ${lib.escapeShellArg "${clientDirectory}/id_ed25519"}
      fi
      ${pkgs.openssh}/bin/ssh-keygen -y -f ${lib.escapeShellArg "${clientDirectory}/id_ed25519"} > ${lib.escapeShellArg "${publicKeysDirectory}/docker_ed25519.pub"}
      ${pkgs.coreutils}/bin/chown ${lib.escapeShellArg dockerCfg.hostUser} ${lib.escapeShellArg "${clientDirectory}/id_ed25519"}
      ${pkgs.coreutils}/bin/chmod 0600 ${lib.escapeShellArg "${clientDirectory}/id_ed25519"}
      ${pkgs.coreutils}/bin/chmod 0644 ${lib.escapeShellArg "${publicKeysDirectory}/docker_ed25519.pub"}
    '';
    nix.linux-builder.config =
      { pkgs, ... }:
      {
        imports = [
          (import ../nixos/docker-builder.nix {
            inherit hostHome;
            dockerPublicKeysDirectory = publicKeysDirectory;
            forwardedPorts = dockerCfg.forwardedPorts;
            dockerStateDirectory = cfg.workingDirectory;
            dockerDiskSizeMiB = dockerCfg.diskSizeMiB;
          })
        ];
        # Rosetta on Sequoia 15.5 and later requires a guest kernel older than Linux 6.13.
        boot.kernelPackages = lib.mkIf (
          lib.versionAtLeast hostMacOSVersion "15.5" && lib.versionOlder hostMacOSVersion "26"
        ) pkgs.linuxPackages_6_12;
      };
  };
}
