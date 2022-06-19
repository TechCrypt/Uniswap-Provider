const TechCUniswapProvider = artifacts.require("TechCUniswapProvider");



const WETH_KOVAN = "0xd0A1E359811322d97991E03f863a0C30C2cF029C";
const KOVAN_UNISWAP_FACTORY = "0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f";
const WETH_MAIN = "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2"
const STORAGE = "0x5B67A7e18896159fe75a066355944F1284c7b429";


module.exports = function (deployer) {
  deployer.deploy(TechCUniswapProvider, WETH_KOVAN, KOVAN_UNISWAP_FACTORY, STORAGE);
};