{ inputs, self, ... }:
let
  inherit (inputs) nixpkgs home-manager;
in
{
  flake = {
    homeConfigurations = {
      "thomasstahl@imar123" =
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
            ];
          };
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          #extraSpecialArgs = inputs // { pkgs = pkgs; };
          extraSpecialArgs = {
            inherit inputs;
            outputs = self;
          };
          modules = [
            ../../home/users/thomasstahl/thomasstahl-imar123.nix
          ];
        };
    };
  };
}
