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

    function transferAdmin(address _newAdmin) public onlyAdmin {
        require(_newAdmin != address(0), "Invalid address");
        admin = _newAdmin;
    }

    function viewMyID() public view returns (string memory, string memory, string memory) {
        require(identities[msg.sender].isIssued, "No ID issued for caller");
        Identity memory id = identities[msg.sender];
        return (id.name, id.nationality, id.idNumber);
    }

    function identityExists(address _user) public view returns (bool) {
        bytes memory tempName = bytes(identities[_user].name);
        return tempName.length > 0;
    }

    function deleteIdentity(address _user) public onlyAdmin {
        require(identityExists(_user), "No identity to delete");
        delete identities[_user];
    }

    // ---------------- NEW FUNCTIONS ---------------- //

    // 5. Allow user to update their own ID (only if issued)
    function updateMyID(string memory _name, string memory _nationality, string memory _idNumber) public {
        require(identities[msg.sender].isIssued, "No ID issued yet for caller");
        identities[msg.sender].name = _name;
        identities[msg.sender].nationality = _nationality;
        identities[msg.sender].idNumber = _idNumber;
    }

    // 6. Batch issue multiple IDs at once (admin only)
    function batchIssueID(address[] memory _users, string[] memory _names, string[] memory _nationalities, string[] memory _idNumbers) public onlyAdmin {
        require(_users.length == _names.length && _names.length == _nationalities.length && _nationalities.length == _idNumbers.length, "Array lengths mismatch");
        for (uint i = 0; i < _users.length; i++) {
            require(!identities[_users[i]].isIssued, "ID already issued for one of the users");
            identities[_users[i]] = Identity(_names[i], _nationalities[i], _idNumbers[i], true);
        }
    }

    // 7. Get full Identity struct of any user (admin only)
    function getFullIdentity(address _user) public view onlyAdmin returns (Identity memory) {
        require(identityExists(_user), "No identity found");
        return identities[_user];
    }

    // 8. Admin can forcibly reset ID details without revoking
    function resetID(address _user) public onlyAdmin {
        require(identityExists(_user), "No identity to reset");
        identities[_user] = Identity("", "", "", false);
    }
}
