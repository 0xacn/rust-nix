{
  description = "A flake template for a rust project";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    gitignore = { url = "github:hercules-ci/gitignore.nix"; flake = false; };

  };

  outputs = inputs@{ self, nixpkgs, flake-utils, ... }:
  flake-utils.lib.eachSystem [ "aarch64-darwin" ] (system: let
    pkgs = nixpkgs.legacyPackages.${system};
    gitignoreSrc = pkgs.callPackage inputs.gitignore { };
  in rec {
    #packages.hello = pkgs.callPackage ./default.nix { inherit gitignoreSrc; };

    legacyPackages = packages;

    defaultPackage = packages.hello;

    devShell = pkgs.mkShell {
      CARGO_INSTALL_ROOT = "${toString ./.}/.cargo";

      buildInputs = with pkgs; [ cargo rustc git ];
    };
  });

}
