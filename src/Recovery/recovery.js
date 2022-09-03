var ethers = require("ethers");

// our Recovery contract instance: 0xefB31C72d33EB40191118194d41f7D10eb8FE1D5
const recoveryInstance = "0xefB31C72d33EB40191118194d41f7D10eb8FE1D5";
// nonce is 1 since this would be the first transaction executed by this new instance
const lostAddress = ethers.Contract.getContractAddress({from: recoveryInstance, nonce: 1});

// result: 0x3b858D9bD992e90037132964085B4FD99eB98228
console.log(lostAddress);

