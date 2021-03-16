pragma solidity ^0.6.0;

import '@openzeppelin/contracts/math/SafeMath.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';

import '../interfaces/IDistributor.sol';
import '../interfaces/IRewardDistributionRecipient.sol';

contract InitialShareDistributor is IDistributor {
    using SafeMath for uint256;

    event Distributed(address pool, uint256 cashAmount);

    bool public once = true;

    IERC20 public share;
    IRewardDistributionRecipient public usdtdicLPPool;
    uint256 public usdtdicInitialBalance;
    IRewardDistributionRecipient public usdtdisLPPool;
    uint256 public usdtdisInitialBalance;

    constructor(
        IERC20 _share,
        IRewardDistributionRecipient _usdtdicLPPool,
        uint256 _usdtdicInitialBalance,
        IRewardDistributionRecipient _usdtdisLPPool,
        uint256 _usdtdisInitialBalance
    ) public {
        share = _share;
        usdtdicLPPool = _usdtdicLPPool;
        usdtdicInitialBalance = _usdtdicInitialBalance;
        usdtdisLPPool = _usdtdisLPPool;
        usdtdisInitialBalance = _usdtdisInitialBalance;
    }

    function distribute() public override {
        require(
            once,
            'InitialShareDistributor: you cannot run this function twice'
        );

        share.transfer(address(usdtdicLPPool), usdtdicInitialBalance);
        usdtdicLPPool.notifyRewardAmount(usdtdicInitialBalance);
        emit Distributed(address(usdtdicLPPool), usdtdicInitialBalance);

        share.transfer(address(usdtdisLPPool), usdtdisInitialBalance);
        usdtdisLPPool.notifyRewardAmount(usdtdisInitialBalance);
        emit Distributed(address(usdtdisLPPool), usdtdisInitialBalance);

        once = false;
    }
}
