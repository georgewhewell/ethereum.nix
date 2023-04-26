{inputs, ...}: {
  imports = [
    inputs.flake-root.flakeModule
    ./checks.nix
    ./ci.nix
    ./formatter.nix
    ./mkdocs.nix
    ./shell.nix
  ];
}
