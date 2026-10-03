{ inputs, self, ... }:
let
  inherit (inputs)
    nixpkgs
    home-manager
    nix-darwin
    nix-homebrew
    mac-app-util
    ;
in
{
  flake = {
    darwinConfigurations = {
      tmmy-mbp =
        let
          system = "aarch64-darwin";
          pkgs = import nixpkgs {
            inherit system;
            config = {
              allowUnfree = true;
              allowUnfreePrediate = _: true;
            };
            overlays = [
              self.overlays.default
              self.overlays.unstable
              self.overlays.qemu-apple-m4
              inputs.fenix.overlays.default
            ];
          };
        in
        nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = inputs // {
            pkgs = pkgs;
          };
          modules = [
            self.darwinModules.linux-builder
            nix-homebrew.darwinModules.nix-homebrew
            mac-app-util.darwinModules.default

            (
              { config, ... }:
              {
                homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
                nix-homebrew = {
                  # Install Homebrew under the default prefix
                  enable = true;
                  # Apple Silicon only
                  enableRosetta = true;
                  # User owning the Homebrew prefix
                  user = "tmmy";
                  package = pkgs.homebrew-tahoe;
                  # Declarative tap mamagement
                  taps = {
                    "homebrew/homebrew-core" = inputs.homebrew-core;
                    "homebrew/homebrew-cask" = inputs.homebrew-cask;
                    "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
                    "nikitabobko/homebrew-tap" = inputs.homebrew-aerospace;
                    "messense/homebrew-macos-cross-toolchains" = inputs.homebrew-cross-toolchains;
                  };
                  # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`
                  mutableTaps = false;
                  # Automatically migrate existing Homebrew installations
                  #autoMigrate = true;
                };
              }
            )
            ../../darwin/tmmy-mbp/configuration.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.sharedModules = [
                mac-app-util.homeManagerModules.default
              ];
              home-manager.users.tmmy = import ../../home/users/tmmy/tmmy-mbp.nix;
              home-manager.backupFileExtension = "backup";
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
            }
          ];
        };

      thst-mbp =
        let
          system = "aarch64-darwin";
          pkgs = import nixpkgs {
            inherit system;
            config = {
              allowUnfree = true;
              allowUnfreePrediate = _: true;
            };
            overlays = [
              self.overlays.default
              self.overlays.unstable
              self.overlays.qemu-apple-m4
              self.overlays.karabiner-elements
              inputs.fenix.overlays.default
            ];
          };
        in
        nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = inputs // {
            pkgs = pkgs;
          };
          modules = [
            self.darwinModules.linux-builder
            nix-homebrew.darwinModules.nix-homebrew
            mac-app-util.darwinModules.default

            self.darwinModules.git

            (
              { config, ... }:
              {
                homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
                nix-homebrew = {
                  # Install Homebrew under the default prefix
                  enable = true;
                  # Apple Silicon only
                  enableRosetta = true;
                  # User owning the Homebrew prefix
                  user = "thomasstahl";
                  package = pkgs.homebrew-tahoe;
                  # Declarative tap mamagement
                  taps = {
                    "homebrew/homebrew-core" = inputs.homebrew-core;
                    "homebrew/homebrew-cask" = inputs.homebrew-cask;
                    "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
                    "nikitabobko/homebrew-tap" = inputs.homebrew-aerospace;
                    "messense/homebrew-macos-cross-toolchains" = inputs.homebrew-cross-toolchains;
                  };
                  # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`
                  mutableTaps = false;
                  # Automatically migrate existing Homebrew installations
                  #autoMigrate = true;
                };
              }
            )
            ../../darwin/thomasstahl-mbp/configuration.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.sharedModules = [
                mac-app-util.homeManagerModules.default
              ];
              home-manager.users.thomasstahl = import ../../home/users/thomasstahl/thomasstahl-thst-mbp.nix;
              home-manager.backupFileExtension = "backup";
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
            }
          ];
        };
      # Expose the package set, including overlays, for convenience.
      #darwinPackages = self.darwinConfigurations."tmmy-mbp".pkgs;
    };
  };
}
