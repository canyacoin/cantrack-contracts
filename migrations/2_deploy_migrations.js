var CanTrack = artifacts.require("../contracts/CanTrack.sol");

module.exports = function(deployer) {
  deployer.deploy(CanTrack);
};
