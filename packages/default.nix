{
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.flake-parts.flakeModules.easyOverlay
  ];

  perSystem = {
    self',
    inputs',
    config,
    pkgs,
    system,
    ...
  }: let
    inherit (pkgs) callPackage;
    inherit (lib.flake) platformPkgs platformApps;

    callPackageUnstable = inputs'.nixpkgs-unstable.legacyPackages.callPackage;
  in {
    packages = platformPkgs system rec {
      # Consensus Clients
      lighthouse = callPackageUnstable ./clients/consensus/lighthouse {};
      prysm = callPackage ./clients/consensus/prysm {inherit bls blst;};
      teku = callPackage ./clients/consensus/teku {};

      # Execution Clients
      erigon = callPackage ./clients/execution/erigon {};
      besu = callPackage ./clients/execution/besu {};
      geth = callPackage ./clients/execution/geth {};
      geth-sealer = callPackage ./clients/execution/geth-sealer {};
      nethermind = callPackage ./clients/execution/nethermind {};

      # Signers
      web3signer = callPackage ./signers/web3signer {};
      dirk = callPackage ./signers/dirk {inherit bls mcl;};

      # Validators
      vouch = callPackage ./validators/vouch {inherit bls mcl;};

      # MEV
      mev-boost = callPackage ./mev/mev-boost {inherit blst;};
      mev-boost-builder = callPackage ./mev/mev-boost-builder {inherit blst;};
      mev-boost-relay = callPackage ./mev/mev-boost-relay {inherit blst;};

      mev-rs = callPackage ./mev/mev-rs {};

      # DVT
      charon = callPackageUnstable ./dvt/charon {inherit bls mcl;};
      ssvnode = callPackage ./dvt/ssvnode {inherit bls mcl;};

      # Utils
      ethdo = callPackage ./utils/ethdo {inherit bls mcl;};
      sedge = callPackage ./utils/sedge {inherit bls mcl;};
      tx-fuzz = callPackage ./utils/tx-fuzz {};
      zcli = callPackage ./utils/zcli {};

      # Dev
      foundry = inputs.foundry-nix.defaultPackage.${system}.overrideAttrs (oldAttrs: {
        meta.platforms = [system];
      });

      # Libs
      evmc = callPackage ./libs/evmc {};
      mcl = callPackage ./libs/mcl {};
      bls = callPackage ./libs/bls {};
      blst = callPackage ./libs/blst {};
    };

    apps = platformApps self'.packages {
      # consensus clients / prysm
      prysm = {
        prysm-beacon-chain.bin = "beacon-chain";
        prysm-validator.bin = "validator";
        prysm-client-stats.bin = "client-stats";
        prysm-ctl.bin = "prysmctl";
      };

      # consensus / teku
      teku.bin = "teku";

      # consensus / lighthouse
      lighthouse.bin = "lighthouse";

      # execution clients
      besu.bin = "besu";
      erigon.bin = "erigon";

      geth = {
        bin = "geth";
        geth-abidump.bin = "abidump";
        geth-abigen.bin = "abigen";
        geth-bootnode.bin = "bootnode";
        geth-clef.bin = "clef";
        geth-devp2p.bin = "devp2p";
        geth-ethkey.bin = "ethkey";
        geth-evm.bin = "evm";
        geth-faucet.bin = "faucet";
        geth-rlpdump.bin = "rlpdump";
      };

      geth-sealer.bin = "geth";

      nethermind = {
        nethermind.bin = "Nethermind.Cli";
        nethermind-runner.bin = "Nethermind.Runner";
      };

      # dvt
      charon.bin = "charon";
      ssvnode.bin = "ssvnode";

      # mev
      mev-boost-builder.bin = "geth";
      mev-boost-relay.bin = "mev-boost-relay";
      mev-boost.bin = "mev-boost";

      mev-rs.bin = "mev";

      # Signers
      dirk.bin = "dirk";

      # Validators
      vouch.bin = "vouch";

      # Dev
      foundry = {
        anvil.bin = "anvil";
        cast.bin = "cast";
        forge.bin = "forge";
      };

      # utils
      ethdo.bin = "ethdo";
      sedge.bin = "sedge";
      zcli.bin = "zcli";
    };

    overlayAttrs = self'.packages;
  };
}
