{
  blst,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "mev-boost";
  version = "1.6.4844-dev1";

  src = fetchFromGitHub {
    owner = "flashbots";
    repo = "${pname}";
    rev = "v${version}";
    hash = "sha256-YGlkIYqZTs1THdxxeSUvmD4is9kpewHwow1DkkukLI4=";
  };

  vendorHash = "sha256-xw3xVbgKUIDXu4UQD5CGftON8E4o1u2FcrPo3n6APBE=";

  buildInputs = [blst];

  subPackages = ["cmd/mev-boost"];

  meta = {
    description = "MEV-Boost allows proof-of-stake Ethereum consensus clients to source blocks from a competitive builder marketplace";
    homepage = "https://github.com/flashbots/mev-boost";
    mainProgram = "mev-boost";
    platforms = ["x86_64-linux"];
  };
}
