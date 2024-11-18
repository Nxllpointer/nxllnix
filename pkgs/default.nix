inputs:
final: prev: {
  rhythia = final.callPackage ./rhythia {
    inherit (inputs) rhythia-git;
  };
  opentabletdriver = inputs.opentabletdriver.packages.${prev.system}.opentabletdriver;
}
