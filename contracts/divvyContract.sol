pragma solidity >=0.4.21 <0.6.0;

contract divvyContract {
    address payable us = 0xA31b3118497b0F7ea57521165953294dF7C66648;
    address payable manufacturer;
    address payable shipment;

    uint ethPerUser;
    uint totalUsers;

    uint productCost;
    uint shippingCost;

    uint deadline;
    bool funded = false;
    bool manuPaid = false;

    mapping (address => bool) public awaitingContributors;

    event NewFunds(address _who, uint _amount, uint _timestamp);
    event RefundIssued(address _who, uint _amount, uint _timestamp);
    event BeneficiaryPaid(address _beneficiary, uint _amount, uint _timestamp);
    event FundGoalReached(uint _timestamp);
    event OrderComplete(uint _timestamp);

    constructor(address payable _manufacturer, address payable _shipment,
    uint _ethPerUser, uint _desiredCount, uint _productCost,uint _shippingCost,
    uint _durationInHours,
    address [] memory _contributors) public {
        manufacturer = _manufacturer;
        shipment = _shipment;

        ethPerUser = _ethPerUser * 1 ether;
        totalUsers = _desiredCount;

        productCost = _productCost * 1 ether;
        shippingCost = _shippingCost * 1 ether;

        deadline = now + (_durationInHours * 24 hours);

        for (uint i = 0; i < _contributors.length; i++) {
            awaitingContributors[_contributors[i]] = true;
        }
    }

    function fund() public payable {
        require(now < deadline && msg.value >= ethPerUser && !funded && awaitingContributors[msg.sender]);
        awaitingContributors[msg.sender] = false;
        if (address(this).balance == ethPerUser * totalUsers) {
            funded = true;
            emit FundGoalReached(now);
        }
        emit NewFunds(msg.sender, msg.value, now);
    }

    function payManufacturing() public {
        require(funded && !manuPaid &&
                msg.sender == manufacturer
                );
        manuPaid = true;
        msg.sender.transfer(productCost);
    }

    function payShipping(address receiver) public {
        require (awaitingContributors[receiver] && funded &&
                 msg.sender == shipment
                 );
                 //user received package at this point
        awaitingContributors[receiver] = false;
        msg.sender.transfer(shippingCost);
        totalUsers -= 1;
        if (totalUsers == 0) {
            emit OrderComplete(now);
        }
    }

    function payUs() public {
        require (msg.sender == us && totalUsers == 0);
        msg.sender.transfer(address(this).balance);
    }

    function refund() public {
        require(now > deadline && !funded &&
                awaitingContributors[msg.sender] == true
                );

        awaitingContributors[msg.sender] = false;
        msg.sender.transfer(ethPerUser);
        emit RefundIssued(msg.sender, ethPerUser, now);
    }
}
