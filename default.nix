{ pkgs ? import <nixpkgs> {}
, stdenv ? pkgs.stdenv
, lib ? stdenv.lib
# A set providing `buildRustPackage :: attrsets -> derivation`
, rustPlatform ? pkgs.rustPlatform
, fetchFromGitHub ? pkgs.fetchFromGitHub
, gitignoreSrc ? null
, pkgconfig ? pkgs.pkgconfig
, gtk3 ? pkgs.gtk3
, glib ? pkgs.glib
, gobject-introspection ? pkgs.gobject-introspection
}:
}:

let
  gitignoreSource =
    if gitignoreSrc != null
    then gitignoreeSrc.gitignoreSource
    else (import (fetchFromGithub){
        owner = "hercules-ci";
        repo = "gitignore";
        rev = "c4662e662462e7bf3c2a968483478a665d00e717";
        sha256 = "0jx2x49p438ap6psy8513mc1nnpinmhm8ps0a4ngfms9jmvwrlbi";
    }) { inherit lib; }).gitignoreSource;

in
rustPlatform.buildRustPackage rec {
    pname = "rust-nix-template";
    version = "0.1.0";

    src = gitignoreSource ./.;

    buildInputs = [
      gtk3
    ];

    nativeBuildInputs = [ pkgconfig ];
    cargoSha256 = "sha256-0hfmV4mbr3l86m0X7EMYTOu/b+BjueVEbbyQz0KgOFY=";

    meta = with stdenv.lib; {
        homepage = "";
        description = "Template for getting started using rust and nix flakes.";
        license = licenses.apache
      };
}
