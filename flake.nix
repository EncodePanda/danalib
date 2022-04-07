{
  # Nixpkgs / NixOS version to use.
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";
  };

  outputs = { self, nixpkgs }:
    let

      # Generate a user-friendly version number.
      version = builtins.substring 0 8 self.lastModifiedDate;

      # System types to support.
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; overlays = [ self.overlay ]; });

    in
  {
    overlay = final: prev: {};

    apps = forAllSystems (system:
      let
        pkgs = nixpkgsFor."${system}";
      in
      {
        lint-haskell = {
          type = "app";
          program = "${self.linters.${system}.haskell.lintScript}/bin/lint";
        };
      });

    linters = forAllSystems (system:
      let
        pkgs = nixpkgsFor."${system}";
      in
      {
        haskell = import ./linters/haskell.nix { inherit pkgs; };
      });

    internal = forAllSystems (system:
      let
        pkgs = nixpkgsFor."${system}";
      in
      {
        mkDoc = import ./internal/mkdoc.nix {  inherit pkgs; };
      });

      herculesCI.ciSystems = [ "x86_64-linux" ];
  };

}
