{
  description = "elm-select-prism";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        name = "elm-select-prism";

        pkgs = import nixpkgs { inherit system; };

        nodejs = pkgs.nodejs-14_x;
      in
      rec {
        inherit name;
        devShell = pkgs.mkShell {
          inherit name;
          nativeBuildInputs = with pkgs; [
            elmPackages.elm
            elmPackages.elm-format
            nodejs
          ];
        };
      }
    );
}
