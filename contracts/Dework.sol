// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import {FreelancerProfile} from "./types/DeworkTypes.sol";
import {EmployerProfile} from "./types/DeworkTypes.sol";

contract Dework{

    uint256 connectFee = 65536;
    uint256 public hourlyRate = 10;

    address  public initialOwner; //0x0000...

    FreelancerProfile[] public freelancerProfiles;
    EmployerProfile[] public employerProfiles;



    constructor(address _initialOwner){
        initialOwner = _initialOwner;
    }


   
    function getNumberOfRegisteredFreelancers() public view returns(uint256){  
        return freelancerProfiles.length;
    }

     function registerFreelancerProfile(
        string calldata name,
        uint8 experienceYears,
        uint256 hourlyRateWei
     ) external {

        uint256 freelancerId = getNumberOfRegisteredFreelancers();

        FreelancerProfile memory freelancerProfile = FreelancerProfile({
            id: freelancerId,
            name: name,
            wallet:msg.sender,
            experienceYears: experienceYears,
            isAvailableHire: true,
            hourlyRateWei: hourlyRateWei
        });

        freelancerProfiles.push(freelancerProfile);
    }



    function getNumberOfRegisteredEmployers() public view returns(uint256){  
        return employerProfiles.length;
    }


   function registerEmployerProfile(
        string calldata employername) external  {

        uint256 employerId = getNumberOfRegisteredEmployers();

        EmployerProfile memory employerProfile = EmployerProfile({
            id: employerId,
            name: employername,
            wallet:msg.sender,
            isHiring: false
        });

        employerProfiles.push(employerProfile);
    }


    function updateHourlyRate(uint256 _hourlyRate) public{

        hourlyRate = _hourlyRate;
    }

    // function getHourlyRate() public view returns(uint256){

    //     return hourlyRate;
    // }

    function getFreelancerProfile() public view returns(FreelancerProfile[] memory){

        return freelancerProfiles;
    }
}