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
        buildInputs = with pkgs; [
          # godot_4
          nodejs_18
          terra
          fooScript
        ]
        ++ ( with ocamlPackages;
        [
          dune_3
          findlib
          ocaml
          ocaml-lsp
          odoc
          utop
        ]);
        shellHook = ''
          echo "Welcome to Grand-Town in $name"
          export FOO="BAR"
        '';
      };

      defaultPackage.x86_64-linux =
        # Notice the reference to nixpkgs here.
        with import nixpkgs { system = "x86_64-linux"; };
        clang12Stdenv.mkDerivation {
          name = "hello";
          src = self;
          buildPhase = ''
            ls -la
            clang -o hello ./hello.c
          '';
          installPhase = "mkdir -p $out/bin; install -t $out/bin hello";
        };
    };
}
# Good night!
