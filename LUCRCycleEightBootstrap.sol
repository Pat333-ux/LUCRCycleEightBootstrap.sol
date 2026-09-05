// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LUCRCycleEightBootstrap {
    address public governance;

    struct CycleEightBootstrapPoint {
        uint256 blockNum;
        uint256 timestamp;
        bytes32 epochQuantumDeterminismHash;
        bytes32 cycleEightBootstrapHash;
    }

    mapping(uint256 => CycleEightBootstrapPoint) public points;

    event CycleEightBootstrapped(
        uint256 indexed blockNum,
        bytes32 cycleEightBootstrapHash,
        uint256 timestamp
    );

    modifier onlyGovernance() {
        require(msg.sender == governance, "Not governance");
        _;
    }

    constructor() {
        governance = msg.sender;
    }

    function bootstrap(bytes32 epochQuantumDeterminismHash)
        external
        onlyGovernance
        returns (bytes32)
    {
        bytes32 cycleEightBootstrapHash = keccak256(
            abi.encodePacked(
                epochQuantumDeterminismHash,
                block.number,
                block.timestamp,
                blockhash(block.number - 1)
            )
        );

        points[block.number] = CycleEightBootstrapPoint({
            blockNum: block.number,
            timestamp: block.timestamp,
            epochQuantumDeterminismHash: epochQuantumDeterminismHash,
            cycleEightBootstrapHash: cycleEightBootstrapHash
        });

        emit CycleEightBootstrapped(
            block.number,
            cycleEightBootstrapHash,
            block.timestamp
        );

        return cycleEightBootstrapHash;
    }
}
