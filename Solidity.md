### 以太坊

- 一台世界计算机（去中心话，任何人都可以使用）
- 一个状态机（由交易出发的状态转换系统）
- 一个智能合约平台（计算平台）

### 智能合约

可执行的协议规则

智能合约语言：Solidity

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
contract Counter {
    uint public Number;  // 这个变量会一直存在链上
    constructor() {
        Number = 0;
    }
    // Add
    function add(uint num) public {
        Number = Number + num;
    }
}
```

#### 一个合约的组成

#### GAS

GAS是一个工作量单位，复杂度越大，所需gas越多

费用=gas数量*gas单价



###Hardhat

安装

```
npm install —save hardhat
```

创建项目

```
npx hardhat
```

合约编译

```
npx hardhat compile
```

启动本地网络

```
npx hardhat node
```

运行脚本文件

```
npx hardhat run script/xxx_deploy.js [--network ***]
```

Remixd

共享当前文件夹到Remix

`remixd -s Desktop/StuCode/BlockChainStudy/selfStudy -u https://remix.ethereum.org/`

###合约

####根据创建者(sender)的地址以及创建者发送过的交易数量(nonce)来计算确定

`keccak256(rlp.encode([normalize_address(sender), nonce]))[12:]  ` //主要根据发起者和nonce确定

####Create2

` `    //可以人为控制合约地址

```solidity
// senderAddress 发送者地址
// init_code 合约字节码
// salt 盐
keccak256(0xff ++ senderAddress ++ salt ++ keccak256(init_code))[12:]
// 比如下面通过创建test合约为例
function createContract3(uint _salt) public returns (address) {
        test t = new test{salt: keccak256(abi.encode(_salt))}();
        return address(t);
 }
 
 // 预测合约地址
    function getAddress(uint _salt) public view returns (address) {
        bytes memory bytecode = type(test).creationCode;
        //  if constructor
        // bytecode = abi.encodePacked(bytecode, abi.encode(x));

        bytes32 hash = keccak256(
            abi.encodePacked(bytes1(0xff), address(this), keccak256(abi.encode(_salt)), keccak256(bytecode))
        );

        // NOTE: cast last 20 bytes of hash to address
        return address(uint160(uint(hash)));
    }
```

部署地址

0x5B38Da6a701c568545dCfcB03FcB875f56beddC4

合约地址

0xd9145CCE52D386f254917e481eB44e9943F39138

当通过new去创建合约的时候，部署的地址则是合约地址

函数（变量）修饰符

```solidity
public 共有的
private 内部私有的
external 只允许外部访问，
internal 内部可以访问，继承子也可以访问
```

合约函数

```solidity
constructor() 构造函数
视图函数(view)、纯函数:(pure) 不修改状态，不支付手续费
getter 函数: 所有 public 状态变量创建 getter 函数
Payable 修饰符: 表示一个函数可以接收以太币
receive 函数: 接收以太币时回调。
fallback 函数: 没有匹配函数标识符时, fallback 会被调用，如果是转账时，没有receive也有调用fallback
函数修改器(modifier): 可用来改变一个函数的行为，如：检查输入条件、控制访问、重入控制
```

### 继承

super:调用父合约函数

virtual: 表示函数可以被重写 overide: 表示重写了父合约函数

overide: 表示重写了父合约函数

```solidity
pragma solidity ^0.8.0;
contract A {
	uint public a;
	constructor() {
		a = 1;
	}
}
// 使用关键词is继承
//继承时，链上实际只有一个合约被创建，基类合约的代码会被编译进派生合约
//派生合约可以访问基类合约内的所有非私有(private)成员，因此内部(internal)函数和状态变量在派生合约里是可以直接使用的
contract B is A {
	uint public b ;
	constructor() {
		b = 2; 
	}
}
```

### 接口

```solidity

contract Counter {
    uint public count;

    function increment() external {
        count += 1;
    }
}
// 定义接口（常用与调用其他合约的方法，区别于继承的话，gas消耗会比较少，因为继承在部署时相当于把合约代码放在新合约的代码中）
interface ICounter {
    function count() external view returns (uint);
		//接口方法和合约Counter的方法一致时，当引用接口时方法时，则会调用合约的方法
    function increment() external;
}

contract MyContract {
    function incrementCounter(address _counter) external {
    		//此时虽然看调用了接口的increment方法，但是实际是调用了合约Counter的方法，因为传入了合约counter的地址
        ICounter(_counter).increment();
    }

    function getCount(address _counter) external view returns (uint) {
        return ICounter(_counter).count();
    }
}
```

### 库

1. 与合约类似(一个特殊合约)，是函数的封装，用于代码复用。
2. 如果库函数都是 internal 的，库代码会嵌入到合约。
3. 如果库函数有external或 public ，库需要单独部署，并在部署合约时进行链接，使用委托调用
4. 没有状态变量
5. 不能给库发送 Ether
6. 给类型扩展功能:Using lib for type; 如: using SafeMath for uint;

```solidity
library SafeMath {
	function add(uint x, uint y) internal pure returns (uint) {
		uint z = x + y;
		require(z >= x, "uint overflow");
		return z; 
	}
}
contract TestLib {
	using SafeMath for uint;
	function testAdd(uint x, uint y) public pure returns (uint) {
		return x.add(y);
	}
}
```

### 事件

合约与外部世界的重要接口，通知外部世界链上状态的变化

事件有时也作为便宜的存储

使用关键字 event 定义事件，事件不需要实现

使用关键字 emit 触发事件

事件中使用indexed修饰，表示对这个字段建立索引，方便外部对该字段过滤查找

### ABI

Ethereum 智能合约 ABI 用一个 array 表示，其中会包含数个用 JSON 格式表示的 Function 或 Event。根据最新的 Solidity 文件：

##### Function

共有 7 个参数：

1. `name`：a string，function 名称
2. `type`：a string，"function", "constructor", or "fallback"
3. `inputs`：an array，function 输入的参数，包含：
   - `name`：a string，参数名
   - `type`：a string，参数的 data type(e.g. uint256)
   - `components`：an array，如果输入的参数是 tuple(struct) type 才会有这个参数。描述 struct 中包含的参数类型
4. `outputs`：an array，function 的返回值，和 `inputs` 使用相同表示方式。如果沒有返回值可忽略，值为 `[]`
5. `payable`：`true`，function 是否可收 Ether，预设为 `false`
6. `constant`：`true`，function 是否会改写区块链状态，反之为 `false`
7. `stateMutability`：a string，其值可能为以下其中之一："pure"（不会读写区块链状态）、"view"（只读不写区块链状态）、"payable" and "nonpayable"（会改区块链状态，且如可收 Ether 为 "payable"，反之为 "nonpayable"）

#####Event

共有 4 个参数：

1. `name`: a string，event 的名称
2. `type`: a string，always "event"
3. `inputs`: an array，输入参数，包含：
   - `name`: a string，参数名称
   - `type`: a string，参数的 data type(e.g. uint256)
   - `components`: an array，如果输入参数是 tuple(struct) type 才会有这个参数。描述 struct 中包含的信息类型
   - `indexed`: `true`，如果这个参数被定义为 indexed ，反之为 `false`
4. `anonymous`: `true`，如果 event 被定义为 anonymous

#####取得 Ethereum 智能合约 ABI

#####Solidity Compiler

可以用 Solidity Compiler 取得合约 ABI，我使用 JavaScript 版本的 Compiler 为例。

安装：

```
npm install solc -g
```

取得合约 ABI：

```
solcjs simpleStorage.sol --abi
```

会生成一个 simpleStorage_sol_SimpleStorage.abi 文件，里面就是合约ABI 內容。

也可以取得合约的 binary code（二进制码）

```
solcjs your_contract.sol --bin
```



### Token

#### ERC20

[ERC20提案](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md)

```solidity
//Methods
function name() public view returns (string)  //Token全称名字
function symbol() public view returns (string)  // 简称
function decimals() public view returns (uint8)  //
function totalSupply() public view returns (uint256)  //发行量
function balanceOf(address _owner) public view returns (uint256 balance)  //余额
function transfer(address _to, uint256 _value) public returns (bool success)  //转账
function transferFrom(address _from, address _to, uint256 _value) public returns (bool success)  //由from地址转到to地址
function approve(address _spender, uint256 _value) public returns (bool success)  //进行授权
function allowance(address _owner, address _spender) public view returns (uint256 remaining)  //allowance获得授权的数量（_owner授权给_spender的数量）

//Events
event Transfer(address indexed _from, address indexed _to, uint256 _value)
event Approval(address indexed _owner, address indexed _spender, uint256 _value)
```

#### ERC777

[ERC777提案](https://learnblockchain.cn/docs/eips/eip-777.html#%E7%AE%80%E8%A6%81%E8%AF%B4%E6%98%8E)



####ERC721



#### ERC1155



### 授权

Q：合约是怎么使用ERC20 Token的？

A：用户A调用ERC20的Approve(合约B,数量) => 用户A调用合约B的deposite();完成存款

```solidity
pragma solidity ^0.8.0;
contract B {
	mapping(address => uint) deposited;
	function deposite(uint amount) {
		//把用户的Token转移到合约地址中，实现存款
		IERC20.transferFrom(msg.sender, address(this), amount);
		deposited[msg.sender] += amount;
	}
}
```

#### openzeppelin

openzeppelin实现了各种代币的合约实现

```
npm install @openzeppelin/contracts —save-dev //安装openzeppelin
```



![image-20220314175459768](/Users/linchunliang/blog/source/images/image-20220314175459768.png)

### Dapp去中心化应用

#### 中心化应用VS去中心化应用

![image-20220314223216470](/Users/linchunliang/blog/source/images/image-20220314223216470.png)

![image-20220314223248833](/Users/linchunliang/blog/source/images/image-20220314223248833.png)

#### 前端和合约交互

- Ethers.js/Web3.js:一套和以太坊区块链进行交互的库，RPC 接 口封装
- 安装`npm install --save ethers`

#### 步骤

- 连接钱包操作
- 初始化合约
- 从合约获取数据，发起交易

























