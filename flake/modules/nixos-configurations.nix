{ inputs, self, ... }:
let
  inherit (inputs) nixpkgs home-manager disko;
in
{
  flake = {
    nixosConfigurations = {
      tmmy-yoga =
        let
          system = "x86_64-linux";
          pkgs = import nixpkgs {
            inherit system;
            config = {
              allowUnfree = true;
              allowUnfreePrediate = _: true;
            };
            overlays = [
              self.overlays.default
              self.overlays.unstable
              self.overlays.ghostty
              inputs.polymc.overlay
              inputs.fenix.overlays.default
            ];
          };
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = inputs // {
            pkgs = pkgs;
          };
          modules = [
            #disko.nixosModules.disko
            #../../nixos/tmmy-yoga/disk-config.nix
            ../../nixos/tmmy-yoga/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.users.tmmy = import ../../home/users/tmmy/tmmy-yoga.nix;
              home-manager.backupFileExtension = "backup";
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
            }
          ];
        };
      felix-mbp =
        let
          system = "x86_64-linux";
          pkgs = import nixpkgs {
            inherit system;
            config = {
              allowUnfree = true;
              allowUnfreePrediate = _: true;
            };
            overlays = [
              self.overlays.default
              self.overlays.unstable
              self.overlays.ghostty
              inputs.polymc.overlay
            ];
          };
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = inputs // {
            pkgs = pkgs;
          };
          modules = [
            disko.nixosModules.disko
            ../../nixos/felix-mbp/disk-config.nix
            ../../nixos/felix-mbp/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.users.felix = import ../../home/users/felix/felix-mbp.nix;
              home-manager.backupFileExtension = "backup";
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
            }
          ];
        };
      clara-mbp =
        let
          system = "x86_64-linux";
          pkgs = import nixpkgs {
            inherit system;
            config = {
              allowUnfree = true;
              allowUnfreePrediate = _: true;
            };
            overlays = [
              self.overlays.default
              self.overlays.unstable
              self.overlays.ghostty
              inputs.polymc.overlay
            ];
          };
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = inputs // {
            pkgs = pkgs;
          };
          modules = [
            disko.nixosModules.disko
            ../../nixos/clara-mbp/disk-config.nix
            ../../nixos/clara-mbp/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.users.clara = import ../../home/users/clara/clara-mbp.nix;
              home-manager.backupFileExtension = "backup";
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
            }
          ];
        };
    };
  };
}
