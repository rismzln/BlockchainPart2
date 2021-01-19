pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

contract bankNegara
{
    address payable owner;
    address[] public allSuspects;
    address[] public allDepositor;
    address[] public allWithdrawer;
    uint limit = 10000000000000000000; //  = 1 ether
    uint balances; 
    // mapping(address => uint) public balances;
    event transactionDeposit(address payable account, uint amount);
    event transactionWithdraw(address payable account, uint amount);
    
    mapping(address => Suspect) public suspects;
    struct Suspect
    {
        address payable suspect;
        uint amount;
    }
    
    mapping(address => Depositor) public depositors;
    struct Depositor
    {
        address payable suspect;
        uint amount;
    }
    
    mapping(address => Withdrawer) public withdrawers;
    struct Withdrawer
    {
        address payable suspect;
        uint amount;
    }
    
    event addDepositor(address payable depositor, uint amount);
    event addWithdrawer(address payable withdrawer, uint amount);
    event addNewSuspect(address payable suspect, uint amount);
    
    
    
    constructor() public
    {
        owner = msg.sender;
    }
    
    // modifier onlyOwner()
    // {
    //     require(msg.sender == owner, "Not Owner");
    //     _;
    // }
    
    function bankBalance() public view returns(uint)
    {
        // return balances[owner];
        return balances; // kalau pakai ni, balance smart contract tak berkurang walaupun dah withdraw
    }
    
    // Accept any incoming amount
    function deposit () public payable 
    {
        if(msg.value < limit)
        {
            balances += msg.value;
            addDepo(msg.sender, msg.value);
            emit transactionDeposit(msg.sender, msg.value);
        }
        else
        {
            balances += msg.value;
            addSuspect(msg.sender, msg.value);
            addDepo(msg.sender, msg.value);
            emit transactionDeposit(msg.sender, msg.value);
        }

    }
    
    function withdraw() public payable
    {
        if(balances >= msg.value)
        {
            balances -= msg.value;
            addWithdraw(msg.sender, msg.value);
            emit transactionWithdraw(msg.sender, msg.value);
        }
        else
        {
            revert("Insufficient balances");
        }
    
    }
    
    // function transfer(address payable _receiver, uint amount) public
    // {
    //     if(balances[msg.sender] >= amount)
    //     {
    //         // _receiver.transfer(amount);
    //         balances[_receiver] += amount;
    //         balances[msg.sender] -= amount;
    //     }
    //     else
    //     {
    //         revert("Insufficient balances");
    //     }
    // }
    
    // function getAccBalances(address _address) public view returns(uint)
    // {
    //     return balances[_address];
    // }
    
    function addSuspect(address payable _suspect, uint _amount) internal
    {
        uint total = suspects[_suspect].amount + _amount;
        allSuspects.push(_suspect);
        suspects[_suspect] = Suspect(_suspect, total);
        emit addNewSuspect(_suspect, total);
    }
    
    function addDepo(address payable _depositor, uint _amount) internal
    {
        uint total = depositors[_depositor].amount + _amount;
        allDepositor.push(_depositor);
        depositors[_depositor] = Depositor(_depositor, total);
        emit addDepositor(_depositor, total);
    }
    
    function addWithdraw(address payable _withdrawer, uint _amount) internal
    {
        uint total = withdrawers[_withdrawer].amount + _amount;
        allWithdrawer.push(_withdrawer);
        withdrawers[_withdrawer] = Withdrawer(_withdrawer, total);
        emit addWithdrawer(_withdrawer, total);
    }
    
    function listOfSuspect() public view returns(address[] memory)
    {
        return(allSuspects);
    }
    
    function getSuspect(address _suspect) public view returns(address, uint)
    {
        return (suspects[_suspect].suspect, suspects[_suspect].amount);
    }
    
    function getDepositorAndWithdrawer() public view returns(address[] memory, address[] memory)
    {

        return(allDepositor, allWithdrawer);
        
        
    }
    
    
    
    
}