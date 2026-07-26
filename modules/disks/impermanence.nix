{
  configuration = {
    globalconfig,
    lib,
    ...
  }:
    lib.mkIf globalconfig.impermanence.enable {
      nixos = {
        config,
        pkgs,
        ...
      }: let
        diskName = "nixos-${config.hostname}";
        rootPartition = config.disko.devices.disk.${diskName}.content.partitions.root;
        subVolumes = rootPartition.content.subvolumes;
      in {
        disko.devices.disk.${diskName} = {
          type = "disk";
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
                  mountOptions = ["umask=0077"];
                  extraArgs = ["-n" "nixos-boot"];
                };
              };
              root = {
                size = "100%";
                content = {
                  type = "btrfs";
                  extraArgs = ["-L" "nixos-btrfs"];
                  mountpoint = "/btrfs-root";
                  subvolumes = {
                    impermanence = {
                      mountOptions = ["compress=zstd" "noatime"];
                    };
                    persisted = {
                      mountpoint = "/persisted";
                      mountOptions = ["compress=zstd" "noatime"];
                    };
                    nix = {
                      mountpoint = "/nix";
                      mountOptions = ["compress=zstd" "noatime"];
                    };
                    swap = {
                      mountpoint = "/swap";
                      mountOptions = ["noatime"];
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

        fileSystems = {
          ${rootPartition.content.mountpoint}.neededForBoot = true;
          ${subVolumes.persisted.mountpoint}.neededForBoot = true;

          "/" = {
            device = rootPartition.device;
            fsType = "btrfs";
            options = ["subvol=impermanence/current"];
          };
        };

        # https://github.com/nix-community/impermanence/pull/322
        boot.initrd.systemd = {
          initrdBin = with pkgs; [
            btrfs-progs
            coreutils
            util-linux
          ];

          services.prune-subvolumes = {
            requiredBy = ["initrd.target"];
            before = ["local-fs-pre.target"];
            after = [
              "initrd-root-device.target"
              "systemd-hibernate-resume.service"
            ];
            unitConfig.DefaultDependencies = false;
            serviceConfig = {
              Type = "oneshot";
              # also print to TTY
              StandardOutput = "journal+console";
              StandardError = "journal+console";
            };
            script = ''
              (
                echo "Impermanence > Bootstrapping..."

                set -u

                DIR="/impermanence"
                mkdir $DIR
                mount -o "subvol=${subVolumes.impermanence.name}" ${rootPartition.device} $DIR || (echo "Unable to mount impermanence subvolume"; exit 1)
                cd $DIR

                COUNTER="./counter"
                CURRENT="./current"

                CURRENT_BOOT_ID=$(cat $COUNTER || echo 1); echo $(($CURRENT_BOOT_ID + 1)) > $COUNTER
                OLD_BOOT=$(( $CURRENT_BOOT_ID - 5 ))

                echo "Impermanence > Creating root #$CURRENT_BOOT_ID"
                btrfs subvolume create ./$CURRENT_BOOT_ID || (echo "Unable to create subvolume"; exit 1)
                ln -sfT ./$CURRENT_BOOT_ID $CURRENT

                echo "Impermanence > Deleting root #$OLD_BOOT"
                btrfs subvolume delete -R ./$OLD_BOOT

                cd /
                umount $DIR

                echo "Impermanence > Finished"
              )
            '';
          };
        };
      };
    };
}
