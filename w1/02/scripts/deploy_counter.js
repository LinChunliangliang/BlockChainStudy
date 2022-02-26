const hre = require("hardhat")

//const prams = process.argv  //用于接收参数

//const value = prams[2]

async function main() {
    // 先执行编译
    // await hre.run('compile');

    // await hre.run("test")

    const Counter = await hre.ethers.getContractFactory("Counter");
    // console.log(Counter)

    //let [first,second] = await hre.ethers.getSigners();

    // let counter = await hre.ethers.getContractAt("Counter",Counter.address,second)


    const counter = await Counter.deploy(100)

    await counter.deployed();

    //console.log(value)

    console.log("This is deploy address:",counter.address);
}

main()
.then(()=>process.exit(0))
    .catch((error)=>{
        console.log(error);
        process.exit(1)
    })