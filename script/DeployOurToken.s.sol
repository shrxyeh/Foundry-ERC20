//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import {Script} from "forge-std/Script.sol";
import {OurToken} from "../src/Token.sol";

contract DeployOurToken is Script {
    uint256 public constant INITIAL_SUPPLY = 1000 ether;

    function run() external returns (OurToken) {
        vm.startBroadcast();
        OurToken Ot = new OurToken(INITIAL_SUPPLY);
        vm.stopBroadcast();
        return Ot;
    }
}
