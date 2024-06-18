// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { Script } from "forge-std/Script.sol";
import { MockV3Aggregator } from "./../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
  uint8 private constant DECIMALS = 8;
  int256 private constant INITIAL_PRICE = 2000e8;

  struct NetworkConfig {
    address priceFeed; // ETH/USD price feed
  }

  NetworkConfig public activeNetworkConfig;

  constructor() {
    if(block.chainid == 1) {
      activeNetworkConfig = getMainnetEthConfig();
    } else if(block.chainid == 11155111) {
      activeNetworkConfig = getSepoliaEthConfig();
    } else if(block.chainid == 421614) {
      activeNetworkConfig = getArbitumSepoliaEthConfig();
    } else {
      activeNetworkConfig = getAnvilEthConfig();
    }
  }

  // ETH/USD Address -> https://docs.chain.link/data-feeds/price-feeds/addresses
  function getMainnetEthConfig() public pure returns (NetworkConfig memory) {
    NetworkConfig memory config = NetworkConfig({priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419});

    return config;
  }

  function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
    NetworkConfig memory config = NetworkConfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});

    return config;
  }

  function getArbitumSepoliaEthConfig() public pure returns (NetworkConfig memory) {
    NetworkConfig memory config = NetworkConfig({priceFeed: 0xd30e2101a97dcbAeBCBC04F14C3f624E67A35165});

    return config;
  }

  function getAnvilEthConfig() public returns (NetworkConfig memory) {
    vm.startBroadcast();
    MockV3Aggregator priceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
    vm.stopBroadcast();

    NetworkConfig memory config = NetworkConfig({priceFeed: address(priceFeed)});

    return config;
  }
}
