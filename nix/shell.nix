{inputs, ...}: {
  imports = [
    inputs.devshell.flakeModule
  ];

  perSystem = {
    pkgs,
    config,
    inputs',
    ...
  }: let
    inherit (pkgs) mkShellNoCC;
    inherit (inputs'.nixpkgs-unstable.legacyPackages) nix-update statix mkdocs;
  in {
    devshells.default = {
      name = "ethereum.nix";
      packages = [
        nix-update
        statix
        mkdocs
        pkgs.python310Packages.mkdocs-material
      ];
    };
  };
}
