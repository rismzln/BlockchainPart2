import {contractAddress, contractABI} from './contract.js';
import { loadWeb3 } from './loading.js'; 

loadWeb3()
var limit = 50000000000000000000
// const web3 = new Web3('HTTP://127.0.0.1:7545')


// async function loadWeb3() 
// {
    
//   if (window.ethereum) 
//   {
//     window.web3 = new Web3(window.ethereum);
//     await window.ethereum.enable()
//   }
//   else if (window.web3) 
//   {
// 	  window.web3 = new Web3(window.web3.currentProvider);
//   }
//   else 
//   {
// 	  window.alert('Non-Ethereum browser detected. You should consider trying MetaMask!');
//   }
// }

const contract = new web3.eth.Contract(
    contractABI,
    contractAddress
);

console.log(web3)

async function main()
{
    const address = await web3.eth.getAccounts();
    console.log(address)
    const res = await contract.methods.bankBalance().call();
    console.log("Bank balances: ", res)
    document.getElementById("bal").innerHTML = "<h3>"+ res +" wei" +"</h3>"

    var listsuspect = await contract.methods.listOfSuspect().call();
    for (var i=0; i<listsuspect.length;i++){
        var count = i+1
        $("#listsus").append("<tr><td> <p class='text-center'>" + count +". " + listsuspect[i] + "</p></td></tr>")
}


    if(res> limit){
        var sus = await contract.methods.getDepositorAndWithdrawer().call();
        console.log("test ",sus)
        for (var i=0; i<sus[0].length;i++){
            // document.getElementById("listdepo").innerHTML = sus[0][i]
            var count = i+1
            $("#listdepo").append("<tr><td>" + count +". " + sus[0][i] + "</td></tr>")
            // console.log(i)
        }

        for (var i=0; i<sus[1].length;i++){
            // document.getElementById("listdepo").innerHTML = sus[0][i]
            var count = i+1
            $("#listwith").append("<tr><td>" + count +". " + sus[1][i] + "</td></tr>")
            // console.log(i)
        }

    }
}

main()

async function deposit(amount)
{
    const address = await web3.eth.getAccounts();
    var res = contract.methods.deposit().send(
        {
            from: address[0],
            value: amount,
            gas: 6721975,
             gasPrice: '30000000'
            // gasLimit: web3.utils.toWei(1000, "ether"),
            // value: web3.utils.toWei(amount, "ether")
        }
    ).then(res =>
        {
            console.log(res)
            return res
        })
        return res
}
    

async function withdraw(amount)
{
    const address = await web3.eth.getAccounts();
    var res = await contract.methods.withdraw().send(
        {
            from: address[0],
            value: amount,
            gas: 6721975,
             gasPrice: '30000000'
            // gasLimit: web3.utils.toWei(1000, "ether"),
            // value: web3.utils.toWei(amount, "ether")
        })
    console.log(res)
    return res
}


$( "#button" ).on( "click", async function(e) {
    e.preventDefault()
    var asd = document.getElementById("amt").value 
    // console.log(asd)
    var res = await deposit(asd);
    // if (res)
    // {
    //     console.log("luar ", res)
    //     location.reload();
    // }

});

$("#button2").on("click", async function(e)
{
    e.preventDefault()
    var asd = document.getElementById("amt2").value 
    // console.log(asd)
    var res = await withdraw(asd)
})

async function getSuspect(){
    var balance = await contract.methods.bankBalance().call()

}