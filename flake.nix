{
  description = "tmmy's NixOS/home-manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin/master";
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
  };

  outputs = { self, nixpkgs, home-manager, darwin, ... } @ inputs: let
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

    #darwinConfigurations = {
    #  tmmy-mbp = let
    #    system = "aarch64-darwin";
    #    pkgs = import nixpkgs {
    #      inherit system;
    #      config = {
    #        allowUnfree = true;
    #        allowUnfreePrediate = _: true;
    #      };
    #    };
    #  in darwin.lib.darwinSystem {
    #    inherit system;
    #    specialArgs = inputs // { pkgs = pkgs; };
    #    modules = [
    #      ./nixos/tmmy-mbp/configuration.nix
    #      home-manager.darwinModules.home-manager {
    #         home-manager.users.tmmy = import ./home/users/tmmy/tmmy-mbp.nix;
    #         home-manager.backupFileExtension = "backup";
    #         home-manager.useGlobalPkgs = true;
    #         home-manager.useUserPackages = true;
    #      }
    #    ];
    #  };
    #};

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
