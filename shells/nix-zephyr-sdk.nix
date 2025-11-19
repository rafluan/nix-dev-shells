{
  pkgs,
  zephyr,
}: let
  # SDK 0.17 with only the target you want
  sdk = zephyr.sdk-0_17.override {
    targets = [
      "arm-zephyr-eabi"
      "aarch64-zephyr-elf"
    ];
  };

  # Consistent Python environment, all using the same python3
  pythonEnv = pkgs.python3.withPackages (ps: [
    ps.pyelftools
    ps.jsonschema # new dependency required by Zephyr scripts
    ps.rpds-py # native backend used by jsonschema
    ps.stringcase # optional helper, if you need it
    ps.west # west CLI
  ]);
in
  pkgs.mkShell {
    packages = [
      sdk
      pythonEnv

      # Host tools do zephyr-nix
      zephyr.hosttools

      # Ferramentas de build
      pkgs.cmake
      pkgs.ninja
    ];

    ZEPHYR_TOOLCHAIN_VARIANT = "zephyr";
    ZEPHYR_SDK_INSTALL_DIR = sdk;

    shellHook = ''
      # Make sure the toolchain is added to PATH
      export PATH="$ZEPHYR_SDK_INSTALL_DIR/arm-zephyr-eabi/bin:$ZEPHYR_SDK_INSTALL_DIR/aarch64-zephyr-elf/bin:$PATH"

      echo "arm-zephyr-eabi-gcc -> $(command -v arm-zephyr-eabi-gcc || echo 'NOT FOUND')"
      echo "Python -> $(command -v python || echo 'NOT FOUND')"
      echo "West -> $(command -v west || echo 'NOT FOUND')"
      echo "Zephyr SDK: $ZEPHYR_SDK_INSTALL_DIR"
    '';
  }
