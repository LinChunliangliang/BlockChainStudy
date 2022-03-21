//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "../math/SafeMath.sol";

contract MYERC20{
     using SafeMath for uint256;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    mapping (address => uint256) private _balances;

    mapping (address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor(string memory name, string memory symbol, uint8 decimals, uint total) public{
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
        _mint(msg.sender, total);
    }

    function name() public view returns (string memory){
        return _name;
    }

    function symbol() public view returns (string memory){
        return _symbol;
    }
    function decimals() public view returns (uint8){
        return _decimals;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns (uint256){
        return _balances[account];
    }

    function transfer(address sender, uint256 amount) public returns (bool success) {
        _transfer(msg.sender, sender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool success){
        _transfer(sender, recipient, amount);
        _approve(sender, recipient, _allowances[recipient][msg.sender].sub(amount));
        return true;
    }

    function approve(address spender, uint256 value) public returns (bool success){
        _approve(msg.sender, spender, value);
        return true;
    }

    function allowance(address owner, address spender) public view returns (uint256 remaining){
        return _allowances[owner][spender];
    }

    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
        return true;
    }

    function _burn(address account, uint256 value) internal {
        require(account != address(0), "ERC20: burn from the zero address");

        _balances[account] = _balances[account].sub(value);
        _totalSupply = _totalSupply.sub(value);
        emit Transfer(account, address(0), value);
    }

    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] = _balances[sender].sub(amount);
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    function _approve(address owner, address spender, uint256 value) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = value;
        emit Approval(owner, spender, value);
    }

    /*

    */
    function _burnFrom(address account, uint256 amount) internal {
        _burn(account, amount);
        _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
    }

    /*
    铸币
    */
    function _mint(address account, uint256 amount) internal {
        require(account != address(0),"ERC20:mint to the zero address");

        require(amount > 0,"Amount must greater than 0");

        _totalSupply.add(amount);
        _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }
}