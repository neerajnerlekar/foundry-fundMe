// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    NetworkConfig public activeNetworkConfig;

    uint8 constant DECIMALS = 8;
    int256 constant INITIAL_ANSWER = 2000e8;

    struct NetworkConfig {
        address priceFeed;
    }

    constructor() {
        if (block.chainid == 84532) {
            activeNetworkConfig = getBaseSepoliaConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getBaseSepoliaConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory baseSepoliaConfig = NetworkConfig({priceFeed: 0x4aDC67696bA383F43DD60A9e78F2C97Fbbfc7cb1});
        return baseSepoliaConfig;
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_ANSWER);
        vm.stopBroadcast();

        NetworkConfig memory anvilEthConfig = NetworkConfig({priceFeed: address(mockPriceFeed)});
        return anvilEthConfig;
    }
}
