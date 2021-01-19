export  async function loadWeb3() 
{
  var web3;
  if (window.ethereum) 
  {
    window.web3 = new Web3(window.ethereum);
    await window.ethereum.enable()
  }
  else if (window.web3) 
  {
	  window.web3 = new Web3(window.web3.currentProvider);
  }
  else 
  {
	  window.alert('Non-Ethereum browser detected. You should consider trying MetaMask!');
  }
}