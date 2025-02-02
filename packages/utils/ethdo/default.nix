{
  buildGoModule,
  fetchFromGitHub,
  clang,
  mcl,
  bls,
  lib,
  ...
}:
buildGoModule rec {
  pname = "ethdo";
  version = "1.32.0";

  src = fetchFromGitHub {
    owner = "wealdtech";
    repo = "ethdo";
    rev = "v${version}";
    hash = "sha256-++dWwP3bbx1oIjJwdt52gkx+N1mzc9j/ZHMBGuvF+Go=";
  };

  runVend = true;
  vendorHash = "sha256-uyPMt2Gy7n1qPh8eahhLHechuHsNd0uRHF9UmJEElE4=";

  nativeBuildInputs = [clang];
  buildInputs = [mcl bls];

  doCheck = false;

  meta = with lib; {
    description = "A command-line tool for managing common tasks in Ethereum 2";
    homepage = "https://github.com/wealdtech/ethdo";
    license = licenses.apsl20;
    mainProgram = "ethdo";
    platforms = ["x86_64-linux" "aarch64-darwin"];
  };
}
