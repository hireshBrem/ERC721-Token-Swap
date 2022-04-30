const TokenSwap = artifacts.require("TokenSwap");
const Ownable = artifacts.require("Ownable");
const TimeManager = artifacts.require("TimeManager");

module.exports = function(deployer) {
  deployer.deploy(TokenSwap).then( async ()=> {
    const tokenswap = await TokenSwap.deployed();
    tokenswap.readString();
    tokenswap.returnNumber;
    return deployer.deploy(Ownable);
  });
};
