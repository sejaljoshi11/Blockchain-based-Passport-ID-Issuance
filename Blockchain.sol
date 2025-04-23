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
}
