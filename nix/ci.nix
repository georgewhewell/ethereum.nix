{
  self,
  inputs,
  ...
}: let
  inherit (builtins) filter match;
in {
  imports = [
    inputs.hercules-ci-effects.flakeModule
  ];

  herculesCI.ciSystems = filter (system: (match ".*-darwin" system) == null) self.systems;
}
