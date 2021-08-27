// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 */
contract Storage {
  struct Info {
      address benefactory;
      uint256 amountOfFundRaised;
      uint256 targetFund;
  }
  
  mapping (address => Info) campaignInfo;
  
  function registerCampaigns(uint256 _targetFund) external {
      address user = msg.sender;
      uint256 target = _targetFund;
      uint256 fundRaised = 0;
      
      Info memory campaign = Info(user, fundRaised, target);
      campaignInfo[user] = campaign;
  }
  
  function donateFunds(address user,uint256 amount) external payable {
      Info memory campaign = campaignInfo[user];
      address benefactory = campaign.benefactory;
      uint256 targetAmount = campaign.targetFund;
      uint256 amountRaised = campaign.amountOfFundRaised;
      
      payable(benefactory).transfer(amount);
      campaign.amountOfFundRaised = amountRaised + amount;
      
      campaignInfo[user] = campaign;
    }
   function getFundsDonated(address user) external view returns(uint256){
       Info memory campaign = campaignInfo[user];
       return campaign.amountOfFundRaised;
   }
}