var Counter = artifacts.require("Counter");

module.exports = async function (callback) {
    var counter = await Counter.deployed()

    let value = await counter.add(10);

    console.log(value)

}