{
  description = "Global cross-compilation and development environments";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    zephyr-nix.url = "github:nix-community/zephyr-nix/master";
  };

  outputs = {
    nixpkgs,
    zephyr-nix,
    ...
  }: let
    forAllSystems = f: nixpkgs.lib.genAttrs ["x86_64-linux"] f;
  in {
    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    devShells = forAllSystems (
      system: let
        pkgs = import nixpkgs {inherit system;};
        zephyr = zephyr-nix.packages.${system};
      in {
        # Add more shells as needed:
        arm64 = import ./shells/nix-arm64-toolchain.nix {inherit pkgs;};
        arm32 = import ./shells/nix-arm32-toolchain.nix {inherit pkgs;};
        zephyr-sdk = import ./shells/nix-zephyr-sdk.nix {inherit pkgs zephyr;};
      }
    );
  };
}
