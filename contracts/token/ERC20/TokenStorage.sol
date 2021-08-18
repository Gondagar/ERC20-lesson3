// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.4;

import "./Lesson3.sol";

contract TokenStorage {
   

    mapping(address => mapping(address => uint256)) public tokensBalances;
    mapping(address => uint256) public ethBalances;
    mapping(address => bool) public allowedTokens;

     address public _owner;

    constructor() {
        _owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == _owner);
        _;
    }

    function updateToken(address token, bool isAllowed) external onlyOwner {
        allowedTokens[token] = isAllowed;
    }

    function deposit() external payable {
        ethBalances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount, address to) external {
        require(ethBalances[msg.sender] >= amount, "Not enought eth balance");
        ethBalances[msg.sender] -= amount;
        (bool success, ) = to.call{value: amount}("");
        require(success, "Withdraw failure");
    }

    function depositToken(address token, uint256 amount) external {
        require(allowedTokens[token], "Token is not allowed for deposit");

        uint256 balanceBefore = IERC20(token).balanceOf(address(this));

        bool success = IERC20(token).transferFrom(msg.sender,address(this),amount);
        require(success, "Deposit failure");

        uint256 balanceAfter = IERC20(token).balanceOf(address(this));

        require(balanceAfter >= balanceBefore, "token transfer owerflow");
        tokensBalances[msg.sender][token] += balanceAfter - balanceBefore;
    }

    function withdrawToken(address token,uint256 amount,address to) external {
        require(tokensBalances[msg.sender][token] >= amount,"Not enought token balance");
        tokensBalances[msg.sender][token] -= amount;
        bool success = IERC20(token).transfer(to, amount);
        require(success, "Withdraw failure");
    }
}
