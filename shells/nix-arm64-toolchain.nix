{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    # Cross compiler and core toolchain
    pkgsCross.aarch64-multiplatform.stdenv.cc
    gcc
    binutils
    gnumake

    # Kernel and bootloader requirements
    bc
    bison
    flex
    dtc
    ncurses
    cpio
    openssl
    perl
    rsync

    # libuuid support (host headers + target library)
    util-linux.dev
    pkgsCross.aarch64-multiplatform.util-linux

    # GnuTLS support (host + cross target)
    gnutls.dev
    pkgsCross.aarch64-multiplatform.gnutls

    # Build utilities
    file
    unzip
    which
    gettext
    pkg-config
    libtool
    automake
    autoconf
    meson
    ninja

    # Python for scripts and bindings
    python3
    (python3.withPackages (ps: with ps; [
      pyyaml
      jsonschema
    ]))
  ];

  # Disable RELRO hardening to avoid ld warning when not supported
  hardeningDisable = [ "relro" ];

  shellHook = ''
    export ARCH=arm64
    export CROSS_COMPILE=aarch64-unknown-linux-gnu-
    export LDFLAGS="$LDFLAGS -Wl,--no-warn-rwx-segments"
    echo "🛠️  ARM64 cross-compilation environment ready: supports Linux, U-Boot, and user-space projects."
  '';
}

