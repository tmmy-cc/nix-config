{
  description = "tmmy's NixOS/home-manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      #inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    #flake-parts.lib.mkFlake {inherit inputs;} {
    #  systems = nixpkgs.lib.systems.flakeExposed;
    #  imports = [ ./flake ];
    #};

    nixosConfigurations = {
      tmmy-yoga = nixpkgs.lib.nixosSystem {
        inherit system;
	modules = [ ./system/tmmy-yoga/configuration.nix ];
      };
    };

    homeConfigurations = {
      tmmy = home-manager.lib.homeManagerConfiguration {
	inherit pkgs;
	modules = [ ./profile/tmmy/home.nix ];
      };
    };
  };
}
