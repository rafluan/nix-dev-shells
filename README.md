# nix-dev-shells

Isolated development environments using Nix Flakes — mainly for cross-compilation 
(ARM64, ARM32, etc.) and other setups I use often. The idea is tokeep reusable shells 
in one place, without duplicating `shell.nix` files across projects.

## How to use

To enter an environment:

```sh
nix develop ~/nix-dev-shells#arm64
```

Or with `direnv`, in your project:

```sh
use flake ~/nix-dev-shells#arm64
```

## Structure

```text
.
├── flake.nix          # Entry point
├── flake.lock         # Auto-generated
└── shells/
    ├── nix-arm32-toolchain.nix
    ├── nix-arm64-toolchain.nix
    ├── nix-zephyr-sdk.nix
    └── ...
```

Each file inside `shells/` defines a dev environment. The flake just exposes them
under named outputs.

## Purpose

Avoid repeating toolchain setups (cross-GCC, headers, libs, etc.) in every project.
This isn’t a package or system config — just a personal toolbox of ready-to-go
environments.

## Requirements

- Nix with flakes enabled (`nix --version` >= 2.4)
- `direnv` (optional but handy)

---

No promises of stability. If something breaks, I’ll fix it when I need it.

## Optional: Registering the flake globally

If you want to use the environments without typing the full path every time, you can
register this flake under a short name:

```sh
nix registry add nix-dev-shells ~/nix-dev-shells
```

Then, you can run:

```sh
nix develop nix-dev-shells#arm64
```

This works globally, from any directory.

## Tip: Listing or removing registered flakes

To see your current flake registry:

```sh
nix registry list
```

To remove a registered flake:

```sh
nix registry remove nix-dev-shells
```
