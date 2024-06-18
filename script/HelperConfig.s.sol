// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { Script } from "forge-std/Script.sol";

contract HelperConfig {
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

  function getAnvilEthConfig() public pure returns (NetworkConfig memory) {
    // TODO
  }
}
