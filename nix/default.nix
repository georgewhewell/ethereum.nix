{inputs, ...}: {
  imports = [
    inputs.flake-root.flakeModule
    ./checks.nix
    ./formatter.nix
    ./mkdocs.nix
    ./shell.nix
  ];
}
