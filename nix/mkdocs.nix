{
  perSystem = {
    lib,
    pkgs,
    ...
  }: let
    inherit
      (pkgs)
      mkdocs
      nixosOptionsDoc
      python310Packages
      runCommand
      stdenv
      writeShellScriptBin
      ;

    my-mkdocs =
      runCommand "my-mkdocs"
      {
        buildInputs = [
          mkdocs
          python310Packages.mkdocs-material
        ];
      } ''
        mkdir -p $out/bin
        cat <<MKDOCS > $out/bin/mkdocs
        #!${pkgs.bash}/bin/bash
        set -euo pipefail
        export PYTHONPATH=$PYTHONPATH
        exec ${mkdocs}/bin/mkdocs "\$@"
        MKDOCS
        chmod +x $out/bin/mkdocs
      '';

    options-doc = let
      eachOptions = with lib;
        filterAttrs
        (_: hasSuffix "options.nix")
        (fs.flattenTree {tree = fs.rakeLeaves ./../modules;});

      eachOptionsDoc = with lib;
        mapAttrs' (
          name: value:
            nameValuePair
            # take geth.options and turn it into just geth
            (head (splitString "." name))
            # generate options doc
            (nixosOptionsDoc {options = evalModules {modules = [value];};})
        )
        eachOptions;

      statements = with lib;
        concatStringsSep "\n"
        (mapAttrsToList (k: v: ''
            path=$out/${k}.md
            cat ${v.optionsCommonMark} >> $path
          '')
          eachOptionsDoc);
    in
      runCommand "nixos-options" {} ''
        mkdir $out
        ${statements}
      '';

    docsPath = "./docs/reference/module-options";
  in {
    packages.docs = stdenv.mkDerivation {
      name = "ethereum-nix-docs";

      src = ./..;

      buildInput = [options-doc];
      nativeBuildInputs = [my-mkdocs];

      buildPhase = ''
        ln -s ${options-doc} ${docsPath}
        mkdocs build
      '';

      installPhase = ''
        mv site $out
      '';

      passthru.serve = writeShellScriptBin "serve" ''
        set -euo pipefail

        # link in options reference
        rm -f ${docsPath}
        ln -s ${options-doc} ${docsPath}

        mkdocs serve
      '';
    };

    devshells.default.commands = let
      category = "Docs";
    in [
      {
        inherit category;
        name = "docs-serve";
        help = "Serve docs";
        command = "nix run .#docs.serve";
      }
      {
        inherit category;
        name = "docs-build";
        help = "Build docs";
        command = "nix run .#docs";
      }
    ];
  };
}
