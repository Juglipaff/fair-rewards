// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FairRewardDistributor {
    struct Distribution {
        uint256 block;
        uint256 rewardPerDA;
        uint256 sumRewardAgePerDA;
    }

    struct Participant {
        uint256 stake;
        uint256 reward;
        uint256 DA;
        uint256 nextID;
        uint256 lastUpdate;
    }

    mapping(uint256 => Distribution) public d;
    mapping(address => Participant) public participants;

    uint256 public ID;
    uint256 public lastUpdate;
    uint256 public T;
    uint256 public totalDA;

    constructor() {
        d[0].block = block.number;
        lastUpdate = block.number;
    }
}
