# Solidity

这是一个自我成长的过程！

## Week1

### 01

- 安装 Metamask
- 并创建好账号 执行一次转账
- 使用 Remix 创建任意一个合约

### 02

- 使用 Hardhat 部署修改后的 Counte
- 使用 Hardhat 测试 Counter
- 写一个脚本调用 count()

## Week2

### 01

- 编写一个Bank合约
-  通过 Metamask 向Bank合约转账ETH 在Bank合约记录每个地址转账金额
-  编写 Bank合约withdraw(), 实现提取出所有的 ETH

### 02

- 编写合约Score，用于记录学生(地址)分数: 仅有老师(用modifier权限控制)可以添加和修改学生分数
- 分数不可以大于 100; 
- 编写合约Teacher 作为老师，通过 IScore 接口调用修改学生分数。

## Week3

### 01

- 发行一个 ERC20Token: 

  - 可动态增发(起始发行量是 0)
  - 通过 ethers.js. 调用合约进行转账

- 编写一个Vault合约:

  - 编写deposite 方法，实现 ERC20 存入 Vault，并记录每个用户存款金额 ， 用从前端调用(Approve，transferFrom)
  -  编写 withdraw 方法，提取用户自己的存款 (前端调用)
  -  前端显示用户存款金额


### 02

- 发行一个 ERC721Token:
  - 使用 ethers.js 解析ERC721 转账
  - 使用 TheGraph 解析ERC721 转账
