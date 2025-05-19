{
  description = "Global cross-compilation and development environments";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

  outputs = { self, nixpkgs }:
    let
      forAllSystems = f: nixpkgs.lib.genAttrs [ "x86_64-linux" ] f;
    in {
      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in {
          # Add more shells as needed:
          arm64 = import ./shells/nix-arm64-toolchain.nix { inherit pkgs; };
          arm32 = import ./shells/nix-arm32-toolchain.nix { inherit pkgs; };
        }
      );
    };
}

