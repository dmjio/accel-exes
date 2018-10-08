{ mkDerivation, accelerate, accelerate-llvm, accelerate-llvm-native
, base, stdenv
}:
mkDerivation {
  pname = "accel-exes";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    accelerate accelerate-llvm accelerate-llvm-native base
  ];
  license = stdenv.lib.licenses.bsd3;
}
