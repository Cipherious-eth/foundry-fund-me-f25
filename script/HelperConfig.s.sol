//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/mockV3Aggregator.sol";
//deploy mocks on a local anvil chain if an rpc url is not provided
//otherwise deploy on the provided live network
contract HelperConfig is Script{
    constructor(){
       if(block.chainid ==11155111){
              activeNetworkConfig = getSepoliaEthConfig();
       }else if(block.chainid == 1){
        activeNetworkConfig = getEthMainnetConfig();
       }else{
        activeNetworkConfig = getOrCreateAnvilEthConfig();
       }
    }
    struct NetworkConfig{
        address priceFeed;
    }
    NetworkConfig public activeNetworkConfig;
    uint256 public constant DECIMALS = 8;
    uint256 public constant INITIAL_PRICE = 2000e8;
    function getSepoliaEthConfig() public pure returns(NetworkConfig memory){
//get sepolia price feed address
    NetworkConfig memory sepoliaConfig = NetworkConfig({
        priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306}
        );
        return sepoliaConfig;
    }
    function getOrCreateAnvilEthConfig() public returns(NetworkConfig memory){
        //return a price feed address
        //deploy a  mock
        //return the mock address
      if (activeNetworkConfig.priceFeed != address(0)){
          return activeNetworkConfig;
        }
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed= new MockV3Aggregator(uint8(DECIMALS),int(INITIAL_PRICE));
        vm.stopBroadcast();
        NetworkConfig memory anvilConfig = NetworkConfig({  
            priceFeed: address(mockPriceFeed)
            });
            return anvilConfig;
    }
    function getEthMainnetConfig() public pure returns(NetworkConfig memory){
        //return a price feed address
        NetworkConfig memory ethMainnetConfig = NetworkConfig({
        priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419}
        );
        return ethMainnetConfig;
    }
}