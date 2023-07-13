{
  inputs = {
    devshell.url = "github:numtide/devshell";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    python-iavl.url = "github:crypto-com/python-iavl";
  };
  outputs = inputs@{ flake-parts, nixpkgs, python-iavl, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ inputs.devshell.flakeModule ];
      systems = [ "aarch64-darwin" ];
      perSystem = { config, pkgs, system, ... }:
        let
          test = let
            env = python-iavl.packages.${system}.iavl-env;
            app = python-iavl.packages.${system}.iavl-cli;
          in pkgs.writeShellScriptBin "test.sh" ''
            ${app.dependencyEnv}/bin/python -c "import os; print(os.environ); from iavl.utils import encode_stdint; print(encode_stdint(int(0)))"
          '';
        in { devshells.default = { packages = [ test ]; }; };
    };
}
