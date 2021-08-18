const TokenStorage = artifacts.require("TokenStorage");


module.exports = function(deployer) {
  deployer.deploy(TokenStorage)
};
