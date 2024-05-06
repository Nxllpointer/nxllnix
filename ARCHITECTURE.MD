# Architecture
This Flake is composed of multiple core building-blocks:
- Configurations
- Profiles
- System/Home modules

## Configurations
Every device has its own configuration.
It consists of 
- The auto-generated `hardware-configuration.nix`,
- The profile selection
- Additional device-specific or makeshift options

## Profiles
A Profile configures top-level options, which are declared in the profile modules.

## System/Home modules
The nix modules to configure regular nixos/home-manager options.
The profile configuration is passed to these modules
and the options are set depending on the profile configuration.