var DivvyContract = artifacts.require("./divvyContract.sol");

var addresses = ["0x084976Cd86b079215d2e20a3b593AFEB6D049a2A",
"0xeA824eb2c276b27042e8c148c2d9535e0c77b7BE",
"0x1E94Bb5700adBB59185De518CE0B9707C90A63c4",
"0x3960003716Ac80261D65E78aCCE62b103F8cd89e",
"0xba2743046af09Ab058A00146BFFD335942917D29"];

module.exports = function(deployer) {
  deployer.deploy(DivvyContract, "0x32a7ce1eC642b2eba89ba0184761e93a0D5561fe", "0x71257eEa06fC71AF67c7F5D2eC91EB67DFfa68e8",
  3, 5, 10, 2, 24, addresses);
};
