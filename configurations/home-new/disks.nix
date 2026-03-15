{ config ? null, lib, ... }:
let
  rootPartition = config.disko.devices.disk.nixos-home-new.content.partitions.root;
  subVolumes = rootPartition.content.subvolumes;
in
{
  disko.devices.disk.nixos-home-new = {
    type = "disk";
    device = "/dev/disk/by-id/wwn-0x5001b444a735ab3e"; # 1TB SSD
    content = {
      type = "gpt";
      partitions = {
        boot = {
          type = "EF00";
          size = "512M";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
            extraArgs = [ "-n" "nixos-boot" ];
          };
        };
        root = {
          size = "100%";
          content = {
            type = "btrfs";
            extraArgs = [ "-L" "nixos-btrfs" ];
            mountpoint = "/btrfs-root";
            subvolumes = {
              impermanence = {
                mountOptions = [ "compress=zstd" "noatime" ];
              };
              persisted = {
                mountpoint = "/persisted";
                mountOptions = [ "compress=zstd" "noatime" ];
              };
              nix = {
                mountpoint = "/nix";
                mountOptions = [ "compress=zstd" "noatime" ];
              };
              swap = {
                mountpoint = "/swap";
                mountOptions = [ "noatime" ];
                swap = {
                  swapfile.size = "16G";
                };
              };
            };
          };
        };
      };
    };
  };

  fileSystems = lib.mkIf (!isNull config) {
    ${rootPartition.content.mountpoint}.neededForBoot = true;
    ${subVolumes.persisted.mountpoint}.neededForBoot = true;

    "/" = {
      device = rootPartition.device;
      fsType = "btrfs";
      options = [ "subvol=impermanence/current" ];
    };
  };

  boot.initrd.postResumeCommands = lib.mkIf (!isNull config) ''
    (
      info "Impermanence > Bootstrapping..."

      set -u

      DIR="/impermanence"
      mkdir $DIR
      mount -o "subvol=${subVolumes.impermanence.name}" ${rootPartition.device} $DIR || fail "Unable to mount impermanence subvolume"
      cd $DIR

      COUNTER="./counter"
      CURRENT="./current"

      CURRENT_BOOT_ID=$(cat $COUNTER || echo 1); echo $(($CURRENT_BOOT_ID + 1)) > $COUNTER
      OLD_BOOT=$(( $CURRENT_BOOT_ID - 5 ))

      info "Impermanence > Creating root #$CURRENT_BOOT_ID"
      btrfs subvolume create ./$CURRENT_BOOT_ID || fail "Unable to create subvolume"
      ln -sfT ./$CURRENT_BOOT_ID $CURRENT

      info "Impermanence > Deleting root #$OLD_BOOT"
      btrfs subvolume delete -R ./$OLD_BOOT

      cd /
      umount $DIR

      info "Impermanence > Finished"
    )
  '';
}
