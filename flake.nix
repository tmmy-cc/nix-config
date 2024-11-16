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

  outputs = { self, nixpkgs, home-manager, darwin, ... } @ inputs:
  {
    nixosConfigurations = {
      tmmy-yoga = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
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
      #tmmy@tmmy-mbp = darwin.lib.darwinSystem {
      #  system = "aarch64-darwin";
      #  modules = [
      #    ./nixos/tmmy-mbp/configuration.nix
      #    home-manager.darwinModules.home-manager {
      #       home-manager.users.tmmy = import ./home/users/tmmy/tmmy-mbp.nix;
      #       home-manager.backupFileExtension = "backup";
      #       home-manager.useGlobalPkgs = true;
      #       home-manager.useUserPackages = true;
      #    }
      #  ];
      #};
    #};
  };
}
