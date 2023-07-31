rec {
  description = "The Grandest Project Ever";
  nixConfig.bash-prompt = "[nix(submania)] ";
  
  inputs = { nixpkgs.url = "github:nixos/nixpkgs/23.05"; };

  outputs = { self, nixpkgs }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux.pkgs;
      fooScript = pkgs.writeScriptBin "foo.sh" ''
        #!/bin/sh
        echo $FOO
      '';
    in {
      devShells.x86_64-linux.default = pkgs.mkShell {
        name = "The Grandest of Build Environments";
        buildInputs = [
          pkgs.ocaml
          pkgs.godot_4
          pkgs.terra
          # pkgs.python311
          # pkgs.python311Packages.tox
          # pkgs.python311Packages.flake8
          # pkgs.python311Packages.requests
          # pkgs.python311Packages.ipython
          fooScript
        ];
        shellHook = ''
          echo "Welcome to Grand-Town in $name"
          export FOO="BAR"
        '';
      };
    };
}