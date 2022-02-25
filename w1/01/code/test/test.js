var Counter = artifacts.require("Counter");

contract("Counter", function(accounts){
    var counterInstance;
    it("Counter", function() {
        return Counter.deployed()
            .then(function(instance) {
                counterInstance = instance;
                return counterInstance.add(20);
            })
            .then(function() {
               return counterInstance.Number();
            }).then(function (count) {
                assert.equal(count,20)
            })
    });
});