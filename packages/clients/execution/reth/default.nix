{
  clang,
  lib,
  llvmPackages,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "reth";
  version = "0.1.0-alpha.4";

  src = fetchFromGitHub {
    owner = "paradigmxyz";
    repo = pname;
    rev = "bdb23b3703bf495cb308defa433fc9b0ef283408";
    hash = "sha256-19BjGRK4z7bSfa9YS8ej2CPjmRVVxxb1pZ05IZbLgUI=";
  };

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
    allowBuiltinFetchGit = true;
    outputHashes = {
      "boa_ast-0.17.0" = "sha256-PPmDXyu0eo+aX3USMBjmQx0kIkJeW+Y3o/gGQ+dnjok=";
      "discv5-0.3.0" = "sha256-f+GfS6+lB5aIgQ08nGajljYOdHTbOj0EL8Bburyo/ao=";
      "igd-0.12.0" = "sha256-wjk/VIddbuoNFljasH5zsHa2JWiOuSW4VlcUS+ed5YY=";
      "revm-3.3.0" = "sha256-jmDzHpbWTXxkv+ATAqYznvcQy8V3EF2XVsCyLaH4p0o=";
      "ruint-1.8.0" = "sha256-OzIUivkNwtox7cMdqv6tkCMsJsGyVeTvfyMr5SZhuPg=";
    };
  };

  nativeBuildInputs = [clang];

  # Needed by libmdx
  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  meta = {
    description = "Modular, contributor-friendly and blazing-fast implementation of the Ethereum protocol, in Rust";
    homepage = "https://github.com/paradigmxyz/reth";
    license = [lib.licenses.mit lib.licenses.asl20];
    mainProgram = "reth";
    platforms = ["x86_64-linux"];
  };
}
