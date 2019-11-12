pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

/*
COPYRIGHT FRAN CASINO. 2019.
SECURITY CHECKS ARE COMMENTED FOR AN EASY USE TEST.
UNCOMMENT THE CODE FOR A FULLY FUNCTIONAL VERSION. 
YOU WILL NEED TO USE METAMASK OR OTHER EXTENSIONS TO USE THE REQUIRED ADDRESSES


ACTUALLY DATA ARE STORED IN THE SC. TO ENABLE IPFS, FUNCTIONS WILL NOT STORE the values and just the hash in the structs.
This can be changed in the code by calling the hash creation function. 
Nevertheless, the code is kept clear for the sake of understanding. 

*/

contract Stakeholders{
 
    struct Stakeholder{
        uint id; // this especific process, containing id and quantity
        string name; // the product
        uint timestamp; // when it was applied, just in case it is not the same date than token creation
        uint [] involvedproducts; // products used by stakeholder
        string description; // other info
        address maker; // who applied this proces
        bool active;
        string hashIPFS; // hash of the elements of the struct, for auditing AND IPFS 
    }

    mapping(uint => Stakeholder) private stakeholderChanges; //

    uint private productsCount;
    uint private stakeholderCount;

    // events, since SC is for global accounts it does not have too much sense but is left here 
    event updateEvent ( // triggers update complete
    );
    
    event changeStatusEvent ( // triggers status change
    );

    address constant public stakeholder = 0xE0f5206BBD039e7b0592d8918820024e2a7437b9; // who registers the product into system. 
    address constant public stakeholder2 = 0xE0F5206bbd039e7b0592d8918820024E2A743222;

    constructor () public { // constructor, inserts new token in system. we map starting from id=1, hardcoded values of all
        addStakeholder("Manufacturer",1573564413,"Manufactures several components CPU, RAM  and chipsets. "); //
        
    }
    
    // add stakeholder to the list. checkers security disabled
    function addStakeholder (string memory _name, uint _timestamp, string memory _description) public {

        stakeholderCount++;
        stakeholderChanges[stakeholderCount].id = stakeholderCount;
        stakeholderChanges[stakeholderCount].name = _name; 
        stakeholderChanges[stakeholderCount].timestamp = _timestamp; 
        stakeholderChanges[stakeholderCount].description = _description; 
        stakeholderChanges[stakeholderCount].active = true; 
        stakeholderChanges[stakeholderCount].maker = msg.sender;
        emit updateEvent(); // trigger event 
    }

    function addStakeholderProduct(uint _id) public {

        stakeholderChanges[stakeholderCount].involvedproducts.push(_id);
        emit updateEvent(); // trigger event 
    }
    
    // get the products managed by the stakeholder
    function getStakeholdersProduct (uint _id) public view returns (uint [] memory)  {
        require(_id > 0 && _id <= stakeholderCount);  // security check avoid memory leaks
        require(msg.sender == stakeholderChanges[_id].maker);
        
        return stakeholderChanges[_id].involvedproducts;
    }

    function changeStatus (uint _id, bool _active) public {
        require(_id > 0 && _id <= stakeholderCount); 
        stakeholderChanges[stakeholderCount].active = _active;
        emit changeStatusEvent(); // trigger event 
    }

    function getStakeholder (uint _id) public view returns (Stakeholder memory)  {
        require(_id > 0 && _id <= stakeholderCount);  
        require(msg.sender == stakeholderChanges[_id].maker); // only if he is the author of the content
        
        return stakeholderChanges[_id];
    }
    
    // returns global number of status, needed to iterate the mapping and to know info.
    function getNumberOfStakeholders () public view returns (uint){    
        //tx.origin
        return stakeholderCount;
    }

}
