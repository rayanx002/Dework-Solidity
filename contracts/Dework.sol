// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import {FreelancerProfile} from "./types/DeworkTypes.sol";
import {EmployerProfile, CreateJobListingInput, JobListing} from "./types/DeworkTypes.sol";

contract Dework{

    uint256 connectFee = 65536;
    uint256 public hourlyRate = 10;

    address  public initialOwner; //0x0000...

    FreelancerProfile[] public freelancerProfiles;
    EmployerProfile[] public employerProfiles;

    mapping(uint256 => address) public freelancerIdToAddress;
    mapping(uint256 => address) public employerIdToAddress;

    event FreelancerProfileRegistered(uint256 freelancerId, address caller);
    event EmployerProfileRegistered(uint256 employerId, address caller);

    error Dework_IncorrectJobCreationFee(uint256 expectedFee, uint256 actualFee);

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

        freelancerIdToAddress[freelancerId] = msg.sender;

        emit FreelancerProfileRegistered(freelancerId, msg.sender);
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
            isHiring: false,
            jobListing: new JobListing[](0)
        });

        employerProfiles.push(employerProfile);
        employerIdToAddress[employerId] = msg.sender;

        emit EmployerProfileRegistered(employerId, msg.sender);
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


    function getCreatedJobList(uint256 employerId) public view returns(uint256){

        employerProfiles[employerId].jobListing.length;
    }

    function _getEmployerProfile(uint256 employerId) internal view returns(EmployerProfile storage){
        return employerProfiles[employerId];

    }



    function createJobListing(
      uint256 employerId,
      CreateJobListingInput calldata jobListingInput
      ) external payable{

        uint256 fixedPriceForJob = jobListingInput.fixedPriceInWei;
        if(msg.value != fixedPriceForJob){
            revert Dework_IncorrectJobCreationFee(fixedPriceForJob, msg.value);
        }


        EmployerProfile storage employerProfile = _getEmployerProfile(employerId);

        uint256 jobId = getCreatedJobList(employerId);

        JobListing memory newJob = JobListing({

            id: jobId,
            title: jobListingInput.title,
            description: jobListingInput.description,
            deadlineTimestamp: jobListingInput.deadlineTimestamp,
            isOpen: true,
            fixedPriceInWei: jobListingInput.fixedPriceInWei,
            hiredFreelancerId: 0,
            hasHiredFreelancer: false,
            isPaid: false
        });

        employerProfile.jobListing.push(newJob);
      }

}