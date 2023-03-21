<script>
import { ethers } from 'ethers'

export default {
    name: 'CreateERC20',
    data(){
        return {
            accunts:[], //所有账号
            account:'',  //部署合约账号

            recipient:'', //
            amount:'',
        
            name:'',  //token名称
            symbol:'',  //符号
            decimal:'', //精度
            supply:'', //供应量
            balance:'',  //余额

            stakeAmount:''  // 质押数量
        }
       

    },
    async created(){
        // 钱包初始化
        await this.initWeb3()


    },
    methods: {
        async initWeb3(){
            if(window.ethereum){
                try {
                    this.accunts = await window.ethereum.enable()
                    
                    this.account = this.accunts[0]
                    this.currProvider = window.ethereum
                    this.provider = new ethers.providers.Web3Provider(window.ethereum)

                    this.signer = this.provider.getSigner()

                    let network = await this.provider.getNetwork()

                    this.chainId = network.chainId
                } catch(e){
                    console.log(e)
                }

            }else{
                alert('Need Install MetaMask')
            }
        },
        async initContract(){
            this.erc20Token = new ethers.Contract()
        }
    }
}
</script>

<template>
    <div>
        <div>
        <br /> Token名称 : {{ name  }}
        <br /> Token符号 : {{  symbol }}
        <br /> Token精度 : {{  decimal }}
        <br /> Token发行量 : {{  supply }}
        <br /> 我的余额 : {{ balance  }}
      </div>

      <div >
        <br />转账到:
        <input type="text" v-model="recipient" />
        <br />转账金额
        <input type="text" v-model="amount" />
        <br />
        <button @click="transfer()"> 转账 </button>
      </div>

    <div >
      <input v-model="stakeAmount" placeholder="输入质押量"/>
      <button @click="permitStake">离线授权存款</button>
    </div>
    </div>
  
</template>

<style scoped>
a {
  color: #42b983;
}
</style>
