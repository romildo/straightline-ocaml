{ nixpkgs ? import <nixpkgs> {} } :

let
  inherit (nixpkgs) pkgs;
  #ocamlPackages = pkgs.ocamlPackages;
  ocamlPackages = pkgs.ocaml-ng.ocamlPackages_4_07;
  #ocamlPackages = pkgs.ocamlPackages_latest;
in

pkgs.stdenv.mkDerivation {
  name = "my-ocaml-env-0";
  buildInputs = [
    ocamlPackages.ocaml
    ocamlPackages.findlib
    ocamlPackages.camomile
    ocamlPackages.merlin
    ocamlPackages.menhir
    pkgs.dune
    pkgs.emacs
    pkgs.vscode
  ];
}
