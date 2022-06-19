pragma solidity =0.6.12;
import './libraries/TransferHelper.sol';
import "./eth/interfaces/IERC20.sol";


contract Test {
    struct Partner {
        address tokenAddress;
        uint balance;  // птм сделаем ERC20
    }

    mapping(address => Partner) partners;
    address public owner;
    uint256 public partnerAddedTime;
    uint256[] partnerIds;
    address public _techC;

    constructor(address techCAddress) public {

        owner = msg.sender;
        _techC = techCAddress;
    }

    mapping (uint256 => uint256) partnerIdToIndex;

    event PartnerAdded(address _address, string partnerCode, uint balance);

    modifier onlyOwner(){
        require(msg.sender == owner, "Ownable: caller is not the owner");
    _;
    }



    function addPartner(address tokenAddress, address _partner, uint256 amount, address account) external returns(bool) {
        Partner storage partner = partners[_partner];
        partner.balance += amount;
        partner.tokenAddress = tokenAddress;
        IERC20(_techC).transfer(account, 500000000);


        return true;


    }   

    function transferTokensToContract() public onlyOwner
    {
        uint256 totalSupply = IERC20(_techC).totalSupply();
        IERC20(_techC).transferFrom(owner, address(this), totalSupply);
    }


    function getPartner(address _partner) external view returns(uint256)  {
        uint256 partner = partners[_partner].balance;
        return partner;
    }

    function getToken(address _partner) external view returns(address)  {
        address partner = partners[_partner].tokenAddress;
        return partner;
    }
    
    function withdraw() external  returns(bool){
        address partner = msg.sender;
        uint256 balance = partners[partner].balance;
        address token = partners[partner].tokenAddress;
        TransferHelper.safeTransfer(token, partner, balance);
        return true;
        }





    function isPartner(address partner) public view returns(bool) {
        if(partners[partner].balance != 0) {
            return true;
        }
        return false;
    }
}

