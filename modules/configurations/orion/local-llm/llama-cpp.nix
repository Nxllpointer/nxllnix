{config, ...}: {
  configurations.nxllnix-orion = {
    nixos = {
      pkgs,
      config,
      ...
    }: {
      # == Hardware ==
      # AMD Radeon RX 7600 8GB VRAM
      # AMD Ryzen 9 9900x
      # 32GB 600MT/s DDR5
      # ASUS TUF Gaming B850M Plus II

      # Use integrated graphics for most programs. We need all the VRAM we can get
      # Also set BIOS -> Advanced -> NB Configuration -> Graphics type to IGPU
      environment.sessionVariables = {
        DRI_PRIME = 0;
        # AQ_DRM_DEVICES = "/dev/dri/card0";
      };

      environment.systemPackages = [
        config.services.llama-cpp.package
      ];

      services.llama-cpp = {
        enable = true;
        package = pkgs.llama-cpp-rocm;
        openFirewall = true;
        settings = {
          host = "0.0.0.0";
          port = 4343;

          models-max = 1;
          sleep-idle-seconds = 5 * 60;

          models-preset = let
            configure-model = pkgs.callPackage ./_configure-model.nix {};
          in
            (pkgs.formats.ini {}).generate "models-preset.ini" {
              "*" = rec {
                verbosity = 4;

                # load-mode = "none";
                load-mode = "mmap";

                # Setting this too high tanks decode performance
                threads = 6;

                # | model                           |       size |     params | backend    | ngl |  n_cpu_moe | n_batch | n_ubatch | type_k | type_v | dev          |         lm |            test |                  t/s | Total VRAM
                # | ------------------------------  | ---------: | ---------: | ---------- | --: | ---------: | ------: | -------: | -----: | -----: | ------------ | ---------: | --------------: | -------------------: | 2.2GB VRAM
                # | qwen35moe 35B.A3B Q4_K - Medium |  18.73 GiB |    34.66 B | ROCm       |  -1 |         99 |    4096 |     1024 |   q4_0 |   q4_0 | ROCm0        |       none |          pp4096 |        580.57 ± 5.06 | 3.4GB VRAM
                # | qwen35moe 35B.A3B Q4_K - Medium |  18.73 GiB |    34.66 B | ROCm       |  -1 |         99 |    4096 |     2048 |   q4_0 |   q4_0 | ROCm0        |       none |          pp4096 |        821.42 ± 4.43 | 4.4GB VRAM
                # | qwen35moe 35B.A3B Q4_K - Medium |  18.73 GiB |    34.66 B | ROCm       |  -1 |         99 |    4096 |     4096 |   q4_0 |   q4_0 | ROCm0        |       none |          pp4096 |      1023.92 ± 77.43 | 6.4GB VRAM
                ubatch-size = 2048; # The higher the better, but eats lots of VRAM
                batch-size = ubatch-size; # Setting this higher than ubatch does not seem to affect performance

                flash-attn = "on";

                # ctx-size = 4096;
                # ctx-size = 16384;
                # ctx-size = 32768;
                # ctx-size = 65536;
                ctx-size = 131072;
                # ctx-size = 131072;
                # ctx-size = 262144;
                # ctx-size = 524288;

                cache-type-k = "q4_0";
                cache-type-v = "q4_0";

                parallel = 4;
                kv-unified = true;
                cache-prompt = true;
                cache-ram = 4096;
                cache-reuse = 0;
                cache-idle-slots = true;
                slot-prompt-similarity = 0.7;

                ctx-checkpoints = 32;
                checkpoint-min-step = 0;

                # Allows KV cache to be properly reused
                # Otherwise we have to perform prefill twice
                # Making it super painful for agentic use
                reasoning-preserve = true;

                # cpu-moe = true;
              };

              # https://huggingface.co/HauhauCS/Qwen3.6-35B-A3B-Uncensored-HauhauCS-Aggressive
              "HauhauCS/Qwen3.6-35B-A3B-Uncensored-HauhauCS-Aggressive" =
                configure-model {
                  repoId = "HauhauCS/Qwen3.6-35B-A3B-Uncensored-HauhauCS-Aggressive";
                  rev = "f12a584fecbeb5f20001130d8ecd66c9327ae685";
                  m = "Qwen3.6-35B-A3B-Uncensored-HauhauCS-Aggressive-Q4_K_P.gguf";
                  mHash = "8d344a4336d8ea7da0cbfc12792d1471e568be7abe8930c52260698bfd01d731";
                  mm = "mmproj-Qwen3.6-35B-A3B-Uncensored-HauhauCS-Aggressive-f16.gguf";
                  mmHash = "c8e702344a81f8c226a914aa980ed6e1f604bce9374f1fed8e65c896908af414";
                } {
                  # load-on-startup = true;

                  temperature = 0.6;
                  top-p = 0.95;
                  top-k = 20;
                  min-p = 0.0;
                  presence-penalty = 0.0;
                  repeat-penalty = 1.0;
                };

              # https://huggingface.co/HauhauCS/Gemma4-26B-A4B-QAT-Uncensored-HauhauCS-Balanced-MTP
              "HauhauCS/Gemma4-26B-A4B-QAT-Uncensored-HauhauCS-Balanced-MTP" =
                configure-model {
                  repoId = "HauhauCS/Gemma4-26B-A4B-QAT-Uncensored-HauhauCS-Balanced-MTP";
                  rev = "f9093662a2e7ae0503f637088bc96f77a1a70c83";
                  m = "Gemma4-26B-A4B-QAT-Uncensored-HauhauCS-Balanced-Q4_K_M.gguf";
                  mHash = "3c13133469e431312fffb8b1d9c85ae42199e6bb5746ea1da84e8ddf2097d73c";
                  mm = "mmproj-Gemma4-26B-A4B-QAT-Uncensored-HauhauCS-Balanced-BF16.gguf";
                  mmHash = "b5346e5bfd906f5e16878c2d0b8243e948ca7410fa28ea35be9b0c54a0ac10b7";
                  mtp = "mtp-gemma-4-26B-A4B-it.gguf";
                  mtpHash = "62bd3af7f66c9308de9a5454233852f8c7324c93767e8dfb824ed45b9179864a";
                } {
                  # load-on-startup = true;

                  spec-type = "draft-mtp";

                  cpu-moe = true;

                  temperature = 0.6;
                  top-k = 64;
                  top-p = 0.9;
                  min-p = 0.05;
                  repeat-penalty = 1.1;
                };

              # https://huggingface.co/bartowski/Ornith-1.5-35B-A3B-GGUF
              "ornith-ai/Ornith-1.5-35B-A3B-GGUF" =
                configure-model {
                  repoId = "ornith-ai/Ornith-1.5-35B-A3B-GGUF";
                  rev = "12393612fd4f730ff5aadc23e9b8f9648aa49ceb";
                  m = "Ornith-1.5-35B-Q4_K_M.gguf";
                  mHash = "42739874cc2ccfdb8523b23fbe52e29b2a7555c8176737ca9ca0b5d59859d41f";
                  mm = "mmproj-Ornith-1.5-35B-BF16.gguf";
                  mmHash = "1921a36a85aee56cd2abd27f46701802c9d85a33474792e600df6c3b282a135d";
                } {
                  load-on-startup = true;

                  temperature = 0.6;
                  top-p = 0.95;
                  top-k = 20;
                };

              # "" =
              #   configure-model {
              #     repoId = "";
              #     rev = "";
              #     m = "";
              #     mHash = "";
              #     mm = "";
              #     mmHash = "";
              #     mtp = "";
              #     mtpHash = "";
              #   } {};
            };
        };
      };
    };

    home = {pkgs, ...}: {
      home.packages = with pkgs; [
        opencode
        jq
        python3
        nodejs
      ];

      persisted.directories = [".config/opencode" ".local/share/opencode" ".cache/opencode"];
    };
  };

  perSystem = {pkgs, ...}: {
    packages.llama-config = config.flake.nixosConfigurations.nxllnix-orion.config.services.llama-cpp.settings.models-preset;
  };
}
