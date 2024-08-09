# moza-racing-wheel-nix
Some Nix packages to get my Moza R5 wheelbase working on NixOS.

# Usage
Copy the `boxflat` and `universal-pidff` folders to `/etc/nixos`:

```sh
sudo cp -r boxflat universal-pidff /etc/nixos/
```

Edit your hardware configuration to enable the kernel driver and add the udev rules for boxflat:

```nix
# /etc/nixos/hardware-configuration.nix
let
  universal-pidff =
    config.boot.kernelPackages.callPackage ./universal-pidff/universal-pidff.nix
    { };
in {
  boot.extraModulePackages = [ universal-pidff ];
  services.udev.extraRules = ''
    SUBSYSTEM=="tty", KERNEL=="ttyACM*", ATTRS{idVendor}=="346e", ACTION=="add", MODE="0666", TAG+="uaccess"
  '';
}
```

Add the boxflat package to your configuration:

```nix
# /etc/nixos/configuration.nix
let
  boxflat = pkgs.callPackage ./boxflat/boxflat.nix;
in {
  environment.systemPackages = [
    boxflat
  ];
}
```

# Flake
You can run boxflat from this repo's flake:

```sh
nix run .#boxflat
```

Without cloning:

```sh
nix run github:danerieber/moza-racing-wheel-nix#boxflat
```

# universal-pidff
This is a driver that enables force feedback for various Moza and Cammus devices. The `universal-pidff` folder contains a Nix package that can be used to install this kernel module.

Source: [JacKeTUs/universal-pidff](https://github.com/JacKeTUs/universal-pidff)

# boxflat
This is a configuration GUI that is a Linux alternative to Moza Pit House. The `boxflat` folder has a Nix derivation that packages the program.

Source: [Lawstorant/boxflat](https://github.com/Lawstorant/boxflat)
