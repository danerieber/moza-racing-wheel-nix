{
  inputs = { utils.url = "github:numtide/flake-utils"; };
  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        boxflat = pkgs.callPackage ./boxflat/boxflat.nix { };
      in {
        packages = { inherit boxflat; };
        apps = {
          boxflat = utils.lib.mkApp { drv = self.packages.${system}.boxflat; };
        };
      });
}
