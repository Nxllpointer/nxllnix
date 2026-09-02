{inputs, ...}: {
  configurations.nxllnix-orion = {
    nixos = {pkgs, ...}: {
      imports = [
        inputs.corecycler.nixosModules.default
      ];

      services.lact.enable = true;
      hardware.amdgpu.overdrive.enable = true;

      services.corecycler = {
        enable = true;
        deviceAccessUser = "nxll";
      };

      environment.systemPackages = [
        (pkgs.mprime.overrideAttrs (prev: {
          src = prev.src.overrideAttrs (prevSrc: {
            urls = [
              (
                # .ca redirects to google drive and shows a popup
                builtins.replaceStrings
                ["https://download.mersenne.ca/gimps/"]
                ["https://www.mersenne.org/download/software/"]
                prev.src.url
              )
            ];
          });
        }))
      ];
    };
  };
}
