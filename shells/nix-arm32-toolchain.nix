{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    # Cross compiler for 32-bit ARM
    pkgsCross.armv7l-hf-multiplatform.stdenv.cc
    gcc
    binutils
    gnumake

    # Kernel and bootloader build tools
    bc
    bison
    flex
    dtc
    ncurses
    cpio
    lz4
    openssl
    perl
    rsync

    # libuuid support (host headers + target library)
    util-linux.dev
    pkgsCross.aarch64-multiplatform.util-linux

    # GnuTLS support (host + cross target)
    gnutls.dev
    pkgsCross.aarch64-multiplatform.gnutls

    # Common build utilities
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

    # Python + bindings tools
    python3
    (python3.withPackages (ps: with ps; [
      pyyaml
      jsonschema
    ]))
  ];

  shellHook = ''
    export ARCH=arm
    export CROSS_COMPILE=armv7l-unknown-linux-gnueabihf-
    echo "🛠️  ARM 32-bit cross-compilation environment ready: supports Linux, U-Boot, and user-space projects."
  '';
}
