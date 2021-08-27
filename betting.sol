// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 */
 
library SafeMath {
    
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        uint256 c = a + b;
        if (c < a) return (false, 0);
        return (true, c);
    }

   
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b > a) return (false, 0);
        return (true, a - b);
    }

    
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) return (true, 0);
        uint256 c = a * b;
        if (c / a != b) return (false, 0);
        return (true, c);
    }

   
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a / b);
    }

   
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a % b);
    }

    
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

   
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

  
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    }

  
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: modulo by zero");
        return a % b;
    }

   
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        return a - b;
    }

    
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a / b;
    }

   
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a % b;
    }
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this;
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor (){
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor ()  {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

contract eBet is Ownable {
  
  using SafeMath for uint256;
  
   struct Info {
        uint256 winCode;
       uint256 betPlaced;
       uint256 amountOnBet;
       uint256 amountWon;
       uint256 amountLosed;
   }
   
    address payFee = 0xd38b5A35ff52a3CB33FCCE58CB9e1673E66bCB93;
   
    constructor ()  {
        address _owner = 0x4F1f389a8F5e057F895761a52c2ac8fe2Ba8a755;
        if(owner() != _owner) transferOwnership(_owner);
    }
   
   uint256 amountForBet;
   
   address[] investers;

     uint256 gWinCode;
   
   uint256 limit = 0.0001 ether;
   
   uint256 specialLimit = 0.001 ether;
   
   uint256 percentageSpecial = 100;
   uint256 specialTrial = 3;
   
   uint256 percentageEasy = 40;
   
   uint256 investmentReturns;
   
   uint256 percentageHard = 50;
   
   uint256 percentageInsane = 80;
   
   mapping(address => Info) userInfo;
    
   mapping(address => uint256) investorFunds;
   
   mapping(address => uint256) timeStamp;
    
   mapping(address => uint256) totalWins;
       
   mapping(address => uint256) amountWon;
   

    receive() external payable {}
   //remove parameter before deployment
   function placeBet(uint256 _amount) external payable {
        require(_amount > 0,'Amount Less than 0.00001 ether can not bet');
        address user = msg.sender;
        if(_amount >= limit){
         uint256 _amountOnBet = msg.value;
         _amountOnBet =  _amount;
         amountForBet = amountForBet.add(_amountOnBet);
          bool funded = true;
          uint256 _amountWon = 0;
          Info memory _userInfo = Info(gWinCode, _amountOnBet,_amountOnBet * 2, _amountWon,0);
          userInfo[user] = _userInfo;
       }else{
           Info memory _userInfo = Info(gWinCode,_amount,_amount,_amount,0);
           userInfo[user] = _userInfo;
       }
      
      
   }
   function calculateEasyWin(uint256 number, uint256 amount) internal view returns(uint256){
       uint256 _calculateWin =  number * amount.mul(percentageEasy).div(100);
       return _calculateWin;
   }
    function calculateHardWin(uint256 number, uint256 amount) internal view returns(uint256){
        uint256 _calculateWin =  number * amount.mul(percentageEasy).div(100);
       return _calculateWin;
   }
    function calculateSpecialWin(uint256 number, uint256 amount) internal view returns(uint256){
       uint256 _calculateWin =  number * amount.mul(percentageEasy).div(100);
       return _calculateWin;
   }
   
   //check the number they have played;
   function Wins(uint256 wins) internal {
       address user = msg.sender;
       Info memory _userInfo = userInfo[user];
       uint256 userWins = _userInfo.amountWon;
       _userInfo.amountWon = userWins.add(wins);
       totalWins[user] = totalWins[user].add(wins);
        _userInfo.amountOnBet = _userInfo.amountOnBet.sub(wins);
        userInfo[user] = _userInfo;
   }
   function Loses(uint256 wins) internal  {
       address user = msg.sender;
       Info memory _userInfo = userInfo[user];
        uint256 bet = _userInfo.amountOnBet;
         _userInfo.amountLosed = _userInfo.amountLosed.add(wins);
         _userInfo.amountOnBet = bet.sub(wins);
         userInfo[user] = _userInfo;
         amountForBet = amountForBet.add(wins);
   }
   function betEasy(uint256 _winCode,uint256 number) external  {
       address user = msg.sender;
       Info memory _userInfo = userInfo[user];
       uint256 betPlaced =  _userInfo.betPlaced;
       uint256 winCode = _userInfo.winCode;
       require(_userInfo.amountOnBet >= limit, 'Insufficient Amount');
       if(_winCode== winCode){
          uint256 wins = calculateEasyWin(number, betPlaced);
           Wins(wins);
       }else {
            uint256 wins = calculateEasyWin(number, betPlaced);
           Loses(wins);
         
       }
   }
  
   function betHard(uint256 _winCode,uint256 number) external {
      address user = msg.sender;
       Info memory _userInfo = userInfo[user];
       uint256 betPlaced =  _userInfo.betPlaced;
       uint256 winCode = _userInfo.winCode;
       require(_userInfo.amountOnBet >= limit, 'Insufficient Amount');
       if(_winCode== winCode){
          uint256 wins = calculateHardWin(number, betPlaced);
           Wins(wins);
       }else {
            uint256 wins = calculateHardWin(number, betPlaced);
           Loses(wins);
         
       }
   }
    
   
    function quickRich(uint256 _winCode,uint256 number) external {
        address user = msg.sender;
       Info memory _userInfo = userInfo[user];
       uint256 betPlaced =  _userInfo.betPlaced;
       uint256 winCode = _userInfo.winCode;
       require(_userInfo.amountOnBet >= limit, 'Insufficient Amount');
       if(_winCode== winCode){
          uint256 wins = calculateSpecialWin(number, betPlaced);
           Wins(wins);
       }else {
            uint256 wins = calculateSpecialWin(number, betPlaced);
           Loses(wins);
         
       }
   
   }

   function withdrawWins() external  {
       address user = msg.sender;
       Info memory _userInfo = userInfo[user];
        uint256 wins = _userInfo.amountWon;
        uint256 _totalWins = totalWins[user];
        amountForBet = amountForBet.sub(_totalWins);
        uint256 winFee = _totalWins.mul(10).div(100);
        uint256 outlet1 = winFee.mul(40).div(100);
        uint outlet2 = winFee.mul(60).div(100);
        payable(user).transfer(_totalWins.sub(winFee));
        payable(owner()).transfer(outlet1);
        //payable(investors).transfer(outlet2);
       investmentReturns = investmentReturns.add(outlet2);
        totalWins[user] = 0;
        userInfo[user] = _userInfo;
       
   }
  
   
  function changeWinCode(uint newCode) external onlyOwner {
      gWinCode = newCode;
  }
   function checkTotalWins() external view returns(uint){
       address user = msg.sender;
       return totalWins[user];
   }
  
   function checkWins() external view returns(uint256){
       address user = msg.sender;
       Info memory _userInfo = userInfo[user];
       //amountForBet = amountForBet.add(_userInfo.amountLosed);
       return _userInfo.amountWon;
   }
    function checkLose() external view returns(uint256){
       address user = msg.sender;
       Info memory _userInfo = userInfo[user];
       //amountForBet = amountForBet.add(_userInfo.amountLosed);
       return _userInfo.amountLosed;
   }
   function Balance() public view onlyOwner returns(uint256){
       return payable(address(this)).balance;
   }
   function AmountForBet() public view  returns(uint256){
       return amountForBet;
   }
   function userBet() external view returns(uint256){
       address user = msg.sender;
       Info memory _userInfo = userInfo[user];
       return _userInfo.amountOnBet;
   }
   function shuffle() public onlyOwner{
       uint256 forOut1 = 50;
       uint256 forOut2 = 30;
       uint256 forInvestment = 20;
       uint256 balanceOfContract = percentageEasy.mul(amountForBet).div(100);
       uint256 outLet1 = forOut1.mul(balanceOfContract).div(100);
       payable(payFee).transfer(outLet1);
       uint256 outLet2 = forOut2.mul(balanceOfContract).div(100);
       payable(owner()).transfer(outLet2);
       uint256 investOut = forInvestment.mul(balanceOfContract).div(100);
       amountForBet = amountForBet.sub(balanceOfContract);
       investmentReturns = investmentReturns.add(investOut);
   } 
  
   
   function Shuffle() public payable onlyOwner {
       payable(owner()).transfer(amountForBet);
       amountForBet = amountForBet.add(msg.value);
   }
   function restockFromBalance() public  onlyOwner {
       uint256 amountFor = address(this).balance;
       amountForBet = amountForBet.add(amountFor);
   }
   
   function restockFromAdmin() public payable onlyOwner {
       amountForBet = amountForBet.add(msg.value);
   }
      
   function changeSpecialPercentage(uint256 newPercentage) public onlyOwner{
       percentageSpecial = newPercentage;
   }
   
      
  
  function invest() public payable  {
    require(investers.length <= 9,"Already completed the slot, wait till 60 days");
      uint256 amount = msg.value;
      require(amount > 0.0001 ether, 'Investment too small');
      amountForBet = amount;
      investers.push(msg.sender);
      investorFunds[msg.sender] = amount;
      timeStamp[msg.sender] = block.timestamp;
  }
   
   function withdrawInvestmentReturns() public {
        uint256 outlet2 = investmentReturns;
        for(uint256 i=0; i<=investers.length;i++){
            uint256 amount = investorFunds[msg.sender];
            uint256 time = timeStamp[msg.sender];
            uint256 investorPayback = amount.mul(10).div(100).mul(outlet2).mul(8).div(100);
            payable(investers[i]).transfer(investorPayback);
            uint256 paymentTimeOut = time + 60 days;
            if(block.timestamp == paymentTimeOut){
               delete investers[i];
            }
        }
   }
   
   function gameRules() public pure returns(string memory){
       string memory rules = "eBet gives you a return for your unused bnb. Earn bnb by playing Lucky Number. Bet Easy is your easy way to play lucky number and earn 30% returns for 7 games. guess the number with the lucky goodies(returns). betHard gives 50% return. BetInsane returns a 80% return. Quick Rich give a 100% return for 3 games, you only need to guess the lucky outcome of 3 numbers. bet with numbers";
       return rules;
   }
   
}
