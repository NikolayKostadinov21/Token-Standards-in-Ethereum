// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract VarnaCoin is IERC20 {

    string private _name;
    string private _symbol;
    uint256 private _totalSupply;

    mapping(address => uint256) private _balances; // Hold the token balance of each owner address
    mapping(address => mapping(address => uint256)) private _allowances; // Including all accounts approved to withdraw from a given account toghether with the withdrawal sum allowed for each. 

    constructor() {
        _name = "Varna Coin";
        _symbol = "VAC";
        _totalSupply = 5000000000000000000000000;
        _balances[msg.sender] = _totalSupply;
        emit Transfer(address(0x0), msg.sender, _totalSupply);
    }

    modifier onlyValidAddresses(address _from, address _to) {
        require(address(_from) != address(0x0), "Invalid address");
        require(address(_to) != address(0x0), "Invalid address");
        _;
    }

    modifier onlyValidBalances(address _from, uint256 _amount) {
        require(_balances[_from] >= _amount, "You are going over the balance over the owner's account");
        require(_amount > 0, "You cannot have zero amount to spend");
        _;
    }

    function name() external view returns (string memory) {
        return _name;
    }

    function symbol() external view returns (string memory) {
        return _symbol;
    }

    function decimals() external pure returns (uint8) {
        return 18;
    } 

    function totalSupply() public virtual view returns (uint256) {
        return _totalSupply;
    }
    
    function balanceOf(address _address) public virtual view returns (uint256) {
        return _balances[_address];
    }

    function allowance(address _owner, address _spender) public virtual view returns (uint256) {
        return _allowances[_owner][_spender];
    }

    function transfer(address _to, uint256 _amount) public virtual onlyValidAddresses(msg.sender, _to) onlyValidBalances(msg.sender, _amount) returns (bool) {
        _balances[msg.sender] -= _amount;
        _balances[_to] += _amount;
        emit Transfer(msg.sender, _to, _amount);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _amount) public virtual onlyValidAddresses(_from, _to) onlyValidBalances(_from, _amount) returns (bool) {
        _balances[_from] -= _amount;
        _allowances[_from][msg.sender] -= _amount;
        _balances[_to] += _amount;
        emit Transfer(_from, _to, _amount);
        return true;
    }

    function approve(address _spender, uint256 _amount) public virtual onlyValidAddresses(msg.sender, _spender) onlyValidBalances(_spender, _amount) returns (bool) {
        _allowances[msg.sender][_spender] = _amount;
        emit Approval(msg.sender, _spender, _amount);
        return true;
    }
}