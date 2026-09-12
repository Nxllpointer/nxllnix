{
  lib,
  runCommand,
  python3Packages,
  fetchurl,
}: {
  repoId,
  rev,
  m,
  mHash,
  mm ? null,
  mmHash ? null,
  mtp ? null,
  mtpHash ? null,
}: settings:
{
  model = fetchurl {
    url = "https://huggingface.co/${repoId}/resolve/${rev}/${m}";
    sha256 = mHash;
  };
}
// lib.optionalAttrs (!isNull mm) {
  mmproj = fetchurl {
    url = "https://huggingface.co/${repoId}/resolve/${rev}/${mm}";
    sha256 = mmHash;
  };
}
// lib.optionalAttrs (!isNull mtp) {
  model-draft = fetchurl {
    url = "https://huggingface.co/${repoId}/resolve/${rev}/${mtp}";
    sha256 = mtpHash;
  };
}
// settings
