// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BlockchainPassportID {
    address public admin;

    struct Identity {
        string name;
        string nationality;
        string idNumber;
        bool isIssued;
    }

    mapping(address => Identity) public identities;

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function issueID(address _user, string memory _name, string memory _nationality, string memory _idNumber) public onlyAdmin {
        require(!identities[_user].isIssued, "ID already issued");
        identities[_user] = Identity(_name, _nationality, _idNumber, true);
    }

    function viewID(address _user) public view returns (string memory, string memory, string memory) {
        require(identities[_user].isIssued, "No ID issued for this user");
        Identity memory id = identities[_user];
        return (id.name, id.nationality, id.idNumber);
    }

    function revokeID(address _user) public onlyAdmin {
        require(identities[_user].isIssued, "ID not issued yet");
        identities[_user].isIssued = false;
    }

    function updateID(address _user, string memory _name, string memory _nationality, string memory _idNumber) public onlyAdmin {
        require(identities[_user].isIssued, "ID not issued yet");
        identities[_user].name = _name;
        identities[_user].nationality = _nationality;
        identities[_user].idNumber = _idNumber;
    }

    function isIDIssued(address _user) public view returns (bool) {
        return identities[_user].isIssued;
    }

    // NEW FUNCTIONS

    // 1. Transfer admin rights to a new address
    function transferAdmin(address _newAdmin) public onlyAdmin {
        require(_newAdmin != address(0), "Invalid address");
        admin = _newAdmin;
    }

    // 2. View your own ID
    function viewMyID() public view returns (string memory, string memory, string memory) {
        require(identities[msg.sender].isIssued, "No ID issued for caller");
        Identity memory id = identities[msg.sender];
        return (id.name, id.nationality, id.idNumber);
    }

    // 3. Check if any identity (issued or not) exists for an address
    function identityExists(address _user) public view returns (bool) {
        bytes memory tempName = bytes(identities[_user].name);
        return tempName.length > 0;
    }

    // 4. Permanently delete identity (admin only)
    function deleteIdentity(address _user) public onlyAdmin {
        require(identityExists(_user), "No identity to delete");
        delete identities[_user];
    }
}
