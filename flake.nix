{
  description = "tmmy's NixOS/home-manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    #nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

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
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko/master";
      inputs.nixpkgs.follows = "nixpkgs";
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
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, nix-homebrew, ... } @ inputs: let
    inherit (self) outputs;
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
            inputs.polymc.overlay
            inputs.fenix.overlays.default
          ];
        };
      in nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = inputs // { pkgs = pkgs; };
        modules = [
          ./nixos/tmmy-yoga/configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager.users.tmmy = import ./home/users/tmmy/tmmy-yoga.nix;
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
            inputs.fenix.overlays.default
          ];
        };
      in nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = inputs // { pkgs = pkgs; };
        modules = [
          nix-homebrew.darwinModules.nix-homebrew {
            nix-homebrew = {
              # Install Homebrew under the default prefix
              enable = true;
              # Apple Silicon only
              #enableRosetta = true;
              # User owning the Homebrew prefix
              user = "tmmy";
              # Declaartive tap mamagement
              taps = {
                "homebrew/homebrew-core" = inputs.homebrew-core;
                "homebrew/homebrew-cask" = inputs.homebrew-cask;
                "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
                "homebrew/homebrew-aerospace" = inputs.homebrew-aerospace;
              };
              # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`
              mutableTaps = false;
              # Automatically migrate existing Homebrew installations
              #autoMigrate = true;
            };
          }
          ./darwin/tmmy-mbp/configuration.nix
          home-manager.darwinModules.home-manager {
             home-manager.users.tmmy = import ./home/users/tmmy/tmmy-mbp.nix;
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
      in home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = { inherit inputs outputs; };
        modules = [
          ./home/users/thomasstahl/thomasstahl-imar123.nix
        ];
      };
    };
  };
}
