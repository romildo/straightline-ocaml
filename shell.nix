{ nixpkgs ? import <nixpkgs> {} } :

let
  inherit (nixpkgs) pkgs;
  ocamlPackages = pkgs.ocamlPackages_latest;
in

pkgs.stdenv.mkDerivation {
  name = "my-ocaml-env-0";
  buildInputs = [
    ocamlPackages.ocaml
    ocamlPackages.ocamlbuild
    ocamlPackages.findlib
    ocamlPackages.camomile
    ocamlPackages.merlin
    ocamlPackages.menhir
    pkgs.dune
    pkgs.emacs
    pkgs.vscode
  ];
}
