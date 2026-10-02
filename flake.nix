{
  description = "tmmy's NixOS/home-manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      #url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-rosetta-builder = {
      url = "github:cpick/nix-rosetta-builder";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixGL = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
    };

    #nixpkgs-wayland = {
    #  url = "github:nix-community/nixpkgs-wayland";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    #secrets = {
    #  url = "";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    #flake-parts = {
    #  url = "github:hercules-ci/flake-parts";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    #nixvim = {
    #  url = "github:nix-community/nixvim";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    polymc = {
      url = "github:PolyMC/PolyMC";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # rust packages
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mac-app-util = {
      url = "github:hraban/mac-app-util";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-aerospace = {
      url = "github:nikitabobko/homebrew-tap";
      flake = false;
    };
    homebrew-cross-toolchains = {
      url = "github:messense/homebrew-macos-cross-toolchains";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nix-darwin, nix-rosetta-builder, nix-homebrew, disko, ghostty, mac-app-util, ... } @ inputs: let
    inherit (self) outputs;
    tmmy-overlay = final: prev: import ./pkgs/overlay.nix inputs final prev;

    unstable-overlay = final: prev: {
      unstable = import nixpkgs-unstable {
        inherit (prev) system;
        inherit (prev) config;
      };
    };
    ghostty-overlay = final: prev: {
      ghostty = import ghostty.packages {
        inherit (prev) system;
        inherit (prev) config;
      };
    };
    qemu-apple-m4-overlay = final: prev: {
      qemu = prev.qemu.overrideAttrs (final: prev: {
        patches = prev.patches ++ [ ./patches/qemu-fix-apple-m4.patch ];
      });
    };
    karabiner-elements-overlay = final: prev: {
      karabiner-elements = prev.karabiner-elements.overrideAttrs (old: {
        version = "14.13.0";

        src = prev.fetchurl {
          inherit (old.src) url;
          hash = "sha256-gmJwoht/Tfm5qMecmq1N6PSAIfWOqsvuHU8VDJY8bLw=";
        };
      });
    };

    homebrew-tahoe = pkgs:
      # Backport Tahoe detection while retaining the pinned Ruby 3.3 runtime.
      (pkgs.applyPatches {
        name = "brew-4.4.5-tahoe";
        src = inputs.nix-homebrew.inputs.brew-src;
        patches = [ (builtins.toFile "homebrew-tahoe.patch" ''
          --- a/Library/Homebrew/macos_version.rb
          +++ b/Library/Homebrew/macos_version.rb
          @@ -21,6 +21,7 @@
             # NOTE: When removing symbols here, ensure that they are added
             #       to `DEPRECATED_MACOS_VERSIONS` in `MacOSRequirement`.
             SYMBOLS = {
          +    tahoe:       "26",
               sequoia:     "15",
               sonoma:      "14",
               ventura:     "13",
          @@ -40,7 +41,9 @@
             sig { params(macos_version: MacOSVersion).returns(Version) }
             def self.kernel_major_version(macos_version)
               version_major = macos_version.major.to_i
          -    if version_major > 10
          +    if version_major >= 26
          +      Version.new((version_major - 1).to_s)
          +    elsif version_major > 10
                 Version.new((version_major + 9).to_s)
               else
                 version_minor = macos_version.minor.to_i
          @@ -56,3 +59,3 @@
             sig { params(version: T.nilable(String)).void }
             def initialize(version)
          -    raise MacOSVersion::Error, version unless /\A1\d+(?:\.\d+){0,2}\Z/.match?(version)
          +    raise MacOSVersion::Error, version unless /\A\d{2,}(?:\.\d+){0,2}\z/.match?(version)
        '') ];
      }) // { version = "4.4.5"; };

    nixosModules = {
    };

    darwinModules = {
      git = import ./modules/darwin/git.nix;
    };
  in
  {
    nixosConfigurations = {
      tmmy-yoga = let
        system = "x86_64-linux";
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            allowUnfreePrediate = _: true;
          };
          overlays = [
            tmmy-overlay
            unstable-overlay
            ghostty-overlay
            inputs.polymc.overlay
            inputs.fenix.overlays.default
          ];
        };
      in nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = inputs // { pkgs = pkgs; };
        modules = [
          #disko.nixosModules.disko
          #./nixos/tmmy-yoga/disk-config.nix
          ./nixos/tmmy-yoga/configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager.users.tmmy = import ./home/users/tmmy/tmmy-yoga.nix;
            home-manager.backupFileExtension = "backup";
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
        ];
      };
      felix-mbp = let
        system = "x86_64-linux";
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            allowUnfreePrediate = _: true;
          };
          overlays = [
            tmmy-overlay
            unstable-overlay
            ghostty-overlay
            inputs.polymc.overlay
          ];
        };
      in nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = inputs // { pkgs = pkgs; };
        modules = [
          disko.nixosModules.disko
          ./nixos/felix-mbp/disk-config.nix
          ./nixos/felix-mbp/configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager.users.felix = import ./home/users/felix/felix-mbp.nix;
            home-manager.backupFileExtension = "backup";
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
        ];
      };
      clara-mbp = let
        system = "x86_64-linux";
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            allowUnfreePrediate = _: true;
          };
          overlays = [
            tmmy-overlay
            unstable-overlay
            ghostty-overlay
            inputs.polymc.overlay
          ];
        };
      in nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = inputs // { pkgs = pkgs; };
        modules = [
          disko.nixosModules.disko
          ./nixos/clara-mbp/disk-config.nix
          ./nixos/clara-mbp/configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager.users.clara = import ./home/users/clara/clara-mbp.nix;
            home-manager.backupFileExtension = "backup";
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
        ];
      };
    };

    darwinConfigurations = {
      tmmy-mbp = let
        system = "aarch64-darwin";
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            allowUnfreePrediate = _: true;
          };
          overlays = [
            tmmy-overlay
            unstable-overlay
            qemu-apple-m4-overlay
            inputs.fenix.overlays.default
          ];
        };
      in nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = inputs // { pkgs = pkgs; };
        modules = [
          nix-rosetta-builder.darwinModules.default
          nix-homebrew.darwinModules.nix-homebrew
          mac-app-util.darwinModules.default

          ({ config, ... }: {
            homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
            nix-homebrew = {
              # Install Homebrew under the default prefix
              enable = true;
              # Apple Silicon only
              enableRosetta = true;
              # User owning the Homebrew prefix
              user = "tmmy";
              package = homebrew-tahoe pkgs;
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
          })
          ./darwin/tmmy-mbp/configuration.nix
          home-manager.darwinModules.home-manager {
            home-manager.sharedModules = [
              mac-app-util.homeManagerModules.default
            ];
            home-manager.users.tmmy = import ./home/users/tmmy/tmmy-mbp.nix;
            home-manager.backupFileExtension = "backup";
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
        ];
      };

      thst-mbp = let
        system = "aarch64-darwin";
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            allowUnfreePrediate = _: true;
          };
          overlays = [
            tmmy-overlay
            unstable-overlay
            qemu-apple-m4-overlay
            karabiner-elements-overlay
            inputs.fenix.overlays.default
          ];
        };
      in nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = inputs // { pkgs = pkgs; };
        modules = [
          nix-rosetta-builder.darwinModules.default
          nix-homebrew.darwinModules.nix-homebrew
          mac-app-util.darwinModules.default

          darwinModules.git

          ({ config, ... }: {
            homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
            nix-homebrew = {
              # Install Homebrew under the default prefix
              enable = true;
              # Apple Silicon only
              enableRosetta = true;
              # User owning the Homebrew prefix
              user = "thomasstahl";
              package = homebrew-tahoe pkgs;
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
          })
          ./darwin/thomasstahl-mbp/configuration.nix
          home-manager.darwinModules.home-manager {
            home-manager.sharedModules = [
              mac-app-util.homeManagerModules.default
            ];
            home-manager.users.thomasstahl = import ./home/users/thomasstahl/thomasstahl-thst-mbp.nix;
            home-manager.backupFileExtension = "backup";
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
        ];
      };
      # Expose the package set, including overlays, for convenience.
      #darwinPackages = self.darwinConfigurations."tmmy-mbp".pkgs;
    };

    homeConfigurations = {
      "thomasstahl@imar123" = let
        system = "x86_64-linux";
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            allowUnfreePrediate = _: true;
          };
          overlays = [
            tmmy-overlay
            unstable-overlay
          ];
        };
      in home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        #extraSpecialArgs = inputs // { pkgs = pkgs; };
        extraSpecialArgs = { inherit inputs outputs; };
        modules = [
          ./home/users/thomasstahl/thomasstahl-imar123.nix
        ];
      };
    };
  };
}
