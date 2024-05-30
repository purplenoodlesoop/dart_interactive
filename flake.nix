{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    core-flake = {
      url = "git+ssh://git@github.com/purplenoodlesoop/core-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , core-flake
    }:
    let
      core = core-flake.lib;
      name = "interactive";

      systemSpecific = { pkgs, toolchains }: with pkgs; {
        shells.default = [ dart yq just ];
        packages.default = callPackage ./packages/interactive/package.nix {
          inherit name;
        };
      };
    in
    core.mkFlake {
      inherit name systemSpecific;
    };
}
