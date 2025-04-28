{
  description = "Typst Invoice Template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        devShells = {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              git
              typst
              typstfmt
              typst-live
              typstyle
              tinymist
            ];

            shellHook = ''
              if command -v nu >/dev/null 2>&1; then
                exec nu
              else
                echo "nu command not found, skipping shellHook"
              fi
            '';
          };
        };
      }
    );
}
