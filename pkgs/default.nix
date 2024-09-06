inputs:
final: prev: {
  rhythia = final.callPackage ./rhythia {
    inherit (inputs) rhythia-git;
  };
}
