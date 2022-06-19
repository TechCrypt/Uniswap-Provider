// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0;

interface IStorage {
    function addPartner(address tokenAddress, address _partner, uint256 amount, address account) external returns (bool);
}
