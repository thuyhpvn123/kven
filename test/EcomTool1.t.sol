// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import {Test, console} from "forge-std/Test.sol";
// pragma solidity 0.8.19;
import "../contracts/interfaces/IEcomProduct.sol";
import "@openzeppelin/contracts@v4.9.0/token/ERC20/IERC20.sol";
import "../contracts/interfaces/IDiscount.sol";
import "../node_modules/@openzeppelin/contracts/utils/Strings.sol";
import {KventureCode} from "../contracts/GenerateCode.sol";
import {PackageInfoStruct} from "../contracts/AbstractPackage.sol";
import {MasterPool} from "../contracts/MasterPool.sol";
import {USDT} from "../contracts/usdt.sol";
import {BinaryTree} from "../contracts/BinaryTree.sol";
import {KVenture} from "../contracts/kventure.sol";
// import {CodePool} from "../contracts/codepool.sol";
import {KProduct} from "../contracts/KvenProduct.sol";
import {KOrder} from "../contracts/Order.sol";
import {KventureNft} from "../contracts/PackageNFT.sol";
import {Mining} from "../contracts/mocks/Mining.sol";
 
import {EcomInfoContract} from "../contracts/EcomInfo.sol";
import {EcomOrderContract} from "../contracts/EcomOrder.sol";
import {EcomUserContract} from "../contracts/EcomUser.sol";
import {EcomProductContract} from "../contracts/EcomProduct.sol";
import {ERC1155Kven} from "../contracts/NFT1155.sol";
import "../contracts/interfaces/INoti.sol";
import {Notification} from "../contracts/mocks/Noti.sol";
import "../contracts/libs/utils.sol";

contract EcomTool1 is Test {
    USDT public USDT_ERC;
    // IERC20 public
    KVenture public PO5;
    address public admin = address(this);
    MasterPool public MONEY_POOL;
    KventureCode public CREATE_CODE;
    BinaryTree public TREE;
    // CodePool public CODE_POOL;
    KProduct public PRODUCT;
    KOrder public ORDER;
    KventureNft public NFT;
    Mining public MINING;
    Notification public NOTIFICATION;

    EcomProductContract public EcomProduct;
    EcomInfoContract public EcomInfo;
    EcomUserContract  public EcomUser;
    EcomOrderContract public EcomOrder;

    ERC1155Kven public posNFT;

    address public Deployer = address(0x1510);
    address public Max_out = address(0x1661);
    address public MTN = address(0x1771);
    address public DTBH = address(0x1881);
    address public DAO_DT = address(0x1551);
    address public NSX = address(0x16969);
    address public Noti = address(0x199999);
    uint256 ONE_USDT = 1_000_000;
    address public Controller = address(0x9999);

    address Sender = address(0x123456);
    // 0xaB3964a5849f9099E26C3C93188F3Bb523beC953
    // This REFCODE: 0x7da8a9411bcd67f365636915ae9120be61782a339734cf5a78a65d5264fc7752
    address public Retailer1 = 0xaB3964a5849f9099E26C3C93188F3Bb523beC953;
    address public Retailer2 = address(this);
    // 8950998090cfa7cd9fa642f1432d29606eb7fd9ad1caa128ec1f839271361941
    uint256 public EXISTS_USER = 3;

    // PackageID: 0x93c60982b015805599742a102ee76b69a734adadf519376fa239dc4061611898
    // StoreID: 0xb72240a3f3563cfd794c62d5c1f9c7920755534f8988e00709db5b33c262a7a7
    // THIS REFCODE: 0x05ab2208d4d6d89860176c9deb67fea28b5479512a6747e14f086a238d84fd7b;
    address public Retailer3 = 0x8Aef0d7d924d1F14Fb9fA31bbF61036A765Ec2Ea;


    bytes32 refCode1 = "refCode1234";
    bytes32 refCode2 = "refCode12345";
    uint256 public TIME = 1910678047; // Friday, July 19, 2030 7:54:07 AM

    function mintUSDT(address user, uint256 amount) internal {
        vm.startPrank(Deployer);
        USDT_ERC.mintToAddress(user, amount * ONE_USDT);
        USDT_ERC.approve(address(PO5), amount * ONE_USDT);
        vm.stopPrank();
    }

    address public pos = address(300);

    function setUp() public {
        vm.startPrank(Sender);
    
        EcomProduct = new EcomProductContract();
        EcomInfo = new EcomInfoContract();
        EcomUser = new EcomUserContract();
        EcomOrder = new EcomOrderContract();
        EcomProduct.SetEcomUser(address(EcomUser));
        EcomProduct.SetEcomInfo(address(EcomInfo));
        EcomProduct.SetEcomOrder(address(EcomOrder));

        EcomInfo.SetEcomUser(address(EcomUser));
        EcomInfo.SetEcomProduct(address(EcomProduct));
        EcomInfo.SetEcomOrder(address(EcomOrder));
        EcomUser.SetEcomProduct(address(EcomProduct));
        EcomUser.SetEcomInfo(address(EcomInfo));
        EcomUser.SetEcomOrder(address(EcomOrder));
        EcomOrder.SetEcomProduct(address(EcomProduct));
        EcomOrder.SetEcomInfo(address(EcomInfo));
        EcomOrder.SetEcomUser(address(EcomUser));
        PO5 = new KVenture();
        USDT_ERC = new USDT();
        MONEY_POOL = new MasterPool(address(USDT_ERC));
        TREE = new BinaryTree(address(PO5));
        CREATE_CODE = new KventureCode();
        NOTIFICATION = new Notification();
        EcomOrder.SetKven(address(PO5));
        EcomOrder.SetMasterPool(address(MONEY_POOL));
        EcomProduct.SetController(Controller);
        EcomOrder.SetPos(pos);
        PO5.initialize(
            address(USDT_ERC),
            address(MONEY_POOL),
            address(TREE),
            Deployer,
            DAO_DT,
            DTBH,
            address(CREATE_CODE),
            MTN,
            Max_out,
            Deployer
        );
        posNFT = new ERC1155Kven();
        posNFT.setController(address(PO5));
        PO5.SetNftPos(address(posNFT));
        PO5.SetProduct(address(EcomOrder));
        EcomOrder.SetUsdt(address(USDT_ERC));
        EcomUser.SetNotification(address(NOTIFICATION));
        MONEY_POOL.setController(address(PO5));
        PO5.setNSX(NSX);
        PO5.SetRefInfo("refCode123", address(0x5555));
        PO5.SetRefInfo("refCode1234", address(0x2222));

        // bytes32 codeRef1;
        bytes32 codeRef2;
        uint256 amount = 900 * 160;
        USDT_ERC.mintToAddress(Sender, amount * ONE_USDT);
        USDT_ERC.approve(address(PO5), amount * ONE_USDT);
        PO5.Register(
            "refCode",
            codeRef2,
            1,
            keccak256(abi.encodePacked(block.timestamp + 1)),
            Retailer1
        );
        vm.stopPrank();
        vm.startPrank(Retailer1);
        bytes32 senderCodeRef1 = PO5.GetCodeRef();
        vm.stopPrank();

        vm.startPrank(Sender);
        USDT_ERC.mintToAddress(Sender, amount * ONE_USDT);
        USDT_ERC.approve(address(PO5), amount * ONE_USDT);
        PO5.Register(
            "refCode",
            senderCodeRef1,
            1,
            keccak256(abi.encodePacked(block.timestamp + 1)),
            Retailer2
        );
        EcomUser.SetKven(address(PO5));
        vm.stopPrank();
        vm.prank(Retailer1);
        EcomUser.registerRetailer("first", "first");
        vm.prank(Retailer2);
        EcomUser.registerRetailer("second", "second");
        createUsers();
    }

    function mintMoneyForUser(address _user, uint256 price) internal {
        vm.prank(Sender);
        USDT_ERC.mintToAddress(_user, price);
        vm.prank(_user);
        USDT_ERC.approve(address(EcomOrder), price);
    }

    function createUsers() internal{
        address User1 = address(4554);
        address User2 = address(4555);
        vm.prank(User1);
        registerParams memory registerParams1 = registerParams({
                fullName: "User1",
                email: "hehe@gmail.com",
                gender: 1,
                dateOfBirth: block.timestamp,
                phoneNumber: "0909090909"
        });
        EcomUser.register(registerParams1);
        vm.prank(User2);
        registerParams memory registerParams2 = registerParams({
                fullName: "User2",
                email: "hehe@gmail.com",
                gender: 1,
                dateOfBirth: block.timestamp,
                phoneNumber: "0909090909"
        });
        EcomUser.register(registerParams2);
    }

    // function test_createCart1() public {
    //     uint256 productID = 1;
    //     uint256 quantity = 1;
    //     bytes memory bytesCall = abi.encodeCall(
    //         productContract.addItemToCart,
    //         (productID, 0x9f2f15d57ffbd1b6b9cf8a8d52e9a501ef2e35907ff34c2306ee02ef828260e8 ,quantity)
    //     );

    //     console.log("Function name: addItemToCart");
    //     console.log("bytesCodeCall: ");
    //     console.logBytes(bytesCall);
    //     console.log(
    //         "-----------------------------------------------------------------------------"
    //     );
    // }


    function test_createOrderInfo() public view{ 
        address user = 0x97126B71376F7e55fBA904FdaA9dF0dBd396612f;

        //total product added, data inside cart
        CreateOrderParams[] memory params = new CreateOrderParams[](1);

        params[0].productID = 1;
        params[0].quantity = 1;
        params[0].variantID = 0x9f2f15d57ffbd1b6b9cf8a8d52e9a501ef2e35907ff34c2306ee02ef828260e8;
        params[0].cartItemId = 2;

        ShippingParams memory shippingParams;
        bytes32 codeRef = 0x05ab2208d4d6d89860176c9deb67fea28b5479512a6747e14f086a238d84fd7b;
        orderDetails memory details = orderDetails(
                0,
                codeRef,
                CheckoutType.RECEIVE,
                PaymentType.VISA
            );

        bytes memory bytesCode = abi.encodeCall(
            EcomOrder.CreateParamsForExecuteOrder,
            (params, shippingParams, user, details)
        );
        console.log("Function name: createOrderInfo");
        console.log("bytesCodeCall: ");
        console.logBytes(bytesCode);
        console.log(
            "-----------------------------------------------------------------------------"
        );
    }


    function test_createOrder() public view {
        address user = 0x8Aef0d7d924d1F14Fb9fA31bbF61036A765Ec2Ea;

        //total product added, data inside cart
        CreateOrderParams[] memory params = new CreateOrderParams[](1);

        params[0].productID = 1;
        params[0].quantity = 1;
        params[0].variantID = 0x9f2f15d57ffbd1b6b9cf8a8d52e9a501ef2e35907ff34c2306ee02ef828260e8;
        params[0].cartItemId = 1;

        ShippingParams memory shippingParams;
        bytes32 codeRef = 0x0ccb9e972c465ac244ff86d3c409dff65ca95635966cf7488cf5a9cfb514ba4f;
        orderDetails memory details = orderDetails(
                0,
                codeRef,
                CheckoutType.STORAGE,
                PaymentType.METANODE
            );

        bytes memory bytesCode = abi.encodeCall(
            EcomOrder.ExecuteOrderUSDT,
            (params, shippingParams, user, details)
        );
        console.log("Function name: ExecuteOrderUSDT");
        console.log("bytesCodeCall: ");
        console.logBytes(bytesCode);
        console.log(
            "-----------------------------------------------------------------------------"
        );
    }

    function test_createShareLink() public view{ 
        uint256[] memory quantities1 = new uint256[](1);
        uint256[] memory productIds1 = new uint256[](1);
        uint256[] memory prices1 = new uint256[](1); 
        bytes32[] memory variants = new bytes32[](1);
        prices1[0] = 500 * ONE_USDT;
        productIds1[0] = 1;
        quantities1[0] = 1;
        variants[0] = 0x9f2f15d57ffbd1b6b9cf8a8d52e9a501ef2e35907ff34c2306ee02ef828260e8;
        ShareLinkParams memory params = ShareLinkParams(
            quantities1,
            productIds1,
            variants,
            prices1,
            1 //parent orderID
        );
       
        // uint256[] memory quantities2 = new uint256[](1);
        // uint256[] memory productIds2 = new uint256[](1);
        // uint256[] memory prices2 = new uint256[](1); 
        // prices2[0] = 300 * ONE_USDT;
        // productIds2[0] = 1;
        // quantities2[0] = 1;
        // ProductContract.ShareLinkParams memory params2 = ProductContract.ShareLinkParams(
        //     quantities2,
        //     productIds1,
        //     prices2,
        //     4
        // );

        ShareLinkParams[] memory newParams = new ShareLinkParams[](1);
        newParams[0] = params;
        // newParams[1] = params2;

        bytes memory bytesCode = abi.encodeCall(
            EcomOrder.createShareLink,
            (newParams, 1910949537) //2030
        );
        console.log("Function name: createShareLink");
        console.log("bytesCodeCall: ");
        console.logBytes(bytesCode);
        console.log(
            "-----------------------------------------------------------------------------"
        );
    }

    function test_createOrderByStorageOrder() public{
            ShippingParams memory shippingParams = ShippingParams(
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            ""
        );
        address user = 0x97126B71376F7e55fBA904FdaA9dF0dBd396612f;
        bytes memory bytesCode = abi.encodeCall(
            EcomOrder.ExecuteOrderStorage,
            (1, user, shippingParams, PaymentType.METANODE) //2030
        );
        console.log("Function name: ExecuteOrderStorage");
        console.log("bytesCodeCall: ");
        console.logBytes(bytesCode);
        console.log(
            "-----------------------------------------------------------------------------"
        );
    }

    function test_adminApproveProduct() public{
        bytes memory bytesCode = abi.encodeCall(
            EcomProduct.adminAcceptProduct,
            (55) //2030
        );
        console.log("Function name: admin approve");
        console.log("bytesCodeCall: ");
        console.logBytes(bytesCode);
        console.log(
            "-----------------------------------------------------------------------------"
        );
    }

}