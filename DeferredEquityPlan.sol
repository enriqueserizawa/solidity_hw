pragma solidity ^0.5.0;

// lvl 3: equity plan
contract DeferredEquityPlan {
    address human_resources;

    address payable employee; // bob
    bool active = true; // this employee is active at the start of the contract

    // @TODO: Set the total shares and annual distribution

    uint total_shares = 1000;
    uint annual_distribution = 250; // annual distribution of 1000 shares for 4 years.

    uint start_time = now; // starting point in time of the contract
    uint unlock_time = now + 365 days; // increment of days per year


    uint start_time = now; // permanently store when the time this contract was initialized

    // @TODO: Set the `unlock_time` to be 365 days from now
    // Your code here!

    uint public distributed_shares; // starts at 0

    constructor(address payable _employee) public {
        human_resources = msg.sender;
        employee = _employee;
    }

   function distribute() public {
        require(msg.sender == human_resources || msg.sender == employee, "Contract access authorization denied");
        require(active == true, "The contract is inactive");
        require(unlock_time <= now, "Shares have to be verified first in order to proceed!");
        require(distributed_shares < total_shares, "No more shares to distribute");

        unlock_time += 365 days; // lock for one more year
        distributed_shares = (now - start_time) / 365 days * annual_distribution; // total shares from passed years multiplied by annual_distribution

        // double check in case the employee does not cash out until after 5+ years
        if (distributed_shares > 1000) {
            distributed_shares = 1000;
        }
    }

    // human_resources and the employee can deactivate this contract at-will
    function deactivate() public {
        require(msg.sender == human_resources || msg.sender == employee, "You are not authorized to deactivate this contract.");
        active = false;
    }

    function() external payable {
        revert("Do not send Ether to this contract!");
    }