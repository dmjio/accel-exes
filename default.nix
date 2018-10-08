{ pkgs ? import <nixpkgs> {} }:
let
  a-src = pkgs.fetchFromGitHub {
    owner = "AccelerateHS";
    repo = "accelerate";
    rev = "c5768ed4af00a54140130d523798a0c424d71ab9";
    sha256 = "0yk5zsbfppvvc6sy246y631sd85pdcpnc58qcb64smdkpzxkbqln";
  };
  a-llvm-src = pkgs.fetchFromGitHub {
    owner = "AccelerateHS";
    repo = "accelerate-llvm";
    rev = "a494652fd371fd30f47501858da1b7c9c3967bf1";
    sha256 = "1nhd7sacr2ilfdrh7sds4352vl1vfg1irzj20vn1065kvyrc37vf";
  };
  primitive-src = pkgs.fetchFromGitHub {
    owner = "haskell";
    repo = "primitive";
    rev = "0bc3b89";
    sha256 = "0fys08j1c88cmcgd6ryqygzsairknkm2849kyn0fjr4hk1nr1iah";
  };
  llvm-hs-src = pkgs.fetchFromGitHub {
    owner = "llvm-hs";
    repo = "llvm-hs";
    rev = "008434c36835f9be7c0b0e4f6fcf755f0ca90ddb";
    sha256 = "0kj0fh1sk97r0hvr0qriwabbvs5j8s20aspf44npnlqqjkqsdqrp";
  };
  overrides = self: super: with pkgs.haskell.lib; {
    mkDerivation = args: super.mkDerivation (args // {
      enableLibraryProfiling = true;
    });
    accelerate = dontCheck super.accelerate;
    primitive = self.callCabal2nix "primitive" primitive-src {};
    llvm-hs = dontCheck (self.callCabal2nix "llvm-hs" "${llvm-hs-src}/llvm-hs" { llvm-config = pkgs.llvm_6; });
    llvm-hs-pure = dontCheck (self.callCabal2nix "llvm-hs-pure" "${llvm-hs-src}/llvm-hs-pure" {});
    accelerate-llvm-native = dontCheck super.accelerate-llvm-native;
  };
  hPkgs = pkgs.haskellPackages.override { inherit overrides; };
in
  hPkgs.callPackage ./pkg.nix {}
