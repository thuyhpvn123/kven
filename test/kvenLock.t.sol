// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {console} from "forge-std/console.sol";
import {Test} from "forge-std/Test.sol";
import {KventureCode} from "../contracts/GenerateCode.sol";
import {PackageInfoStruct} from "../contracts/AbstractPackage.sol";
import {MasterPool} from "../contracts/MasterPool.sol";
import {USDT} from "../contracts/usdt.sol";
import {BinaryTree} from "../contracts/BinaryTree.sol";
import {KVenture} from "../contracts/kventure.sol";
import {KProduct} from "../contracts/KvenProduct.sol";
import {KOrder} from "../contracts/Order.sol";
import {KventureNft} from "../contracts/PackageNFT.sol";
import "../contracts/interfaces/IKventureProduct.sol";
import {ERC1155Kven} from "../contracts/NFT1155.sol";
import "../contracts/kventure.sol";
import {Mining} from "../contracts/mocks/Mining.sol";
contract KventureNewTest is Test {
    MasterPool public MONEY_POOL;
    USDT public USDT_ERC;
    KVenture public PO5;
    KventureCode public CREATE_CODE;
    BinaryTree public TREE;
    KProduct public PRODUCT;
    KOrder public ORDER; 
    KOrder public ORDER1; 
    KventureNft public NFT;
    ERC1155Kven public NFTPOS;
    Mining public MINING;
    address public Deployer = address(0x1510);
    address public MAX_OUT = address(0x1661);
    address public MTN = address(0x1771);
    address public DTBH = address(0x1881);
    address public NSX = address(0x1991);
    address public DAO_DT = address(0x1551);
    uint256 ONE_USDT = 1_000_000;

    // Time Config
    uint256 public currentTime = 1706683205;
    bytes32 codeRef;
    bytes32 codeRef3;
    bytes32 codeRef2;
    bytes32 codeRef4;
    address public POS = address(0x1441);

    // address[] public delegatesArr;
    constructor() {
        vm.startPrank(Deployer);
        //Deploy
        PO5 = new KVenture();
        USDT_ERC = new USDT();
        MONEY_POOL = new MasterPool(address(USDT_ERC));
        TREE = new BinaryTree(address(PO5));
        CREATE_CODE = new KventureCode();
        PRODUCT = new KProduct();
        ORDER = new KOrder();
        ORDER1 = new KOrder();
        NFT = new KventureNft();
        NFTPOS = new ERC1155Kven();
        MINING = new Mining();
        //Call
        //init 
        PO5.initialize(address(USDT_ERC), address(MONEY_POOL), address(TREE), Deployer, DAO_DT, DTBH, address(CREATE_CODE), MTN, MAX_OUT,Deployer);
        // PRODUCT.initialize(address(USDT_ERC),address(MONEY_POOL),address(CREATE_CODE),address(PO5),address(ORDER1));
        PRODUCT.SetKventureCode(address(CREATE_CODE));
        PRODUCT.SetOrder(address(ORDER1));
        PRODUCT.SetUsdt(address(USDT_ERC));
        PRODUCT.SetKventure(address(PO5));
        PRODUCT.SetMasterPool(address(MONEY_POOL));
        CREATE_CODE.initialize(address(USDT_ERC), address(MONEY_POOL), address(0x01), address(PRODUCT), address(NFT), address(PO5), address(0x02));
        CREATE_CODE.SetProduct(address(PRODUCT));
        NFT.grantRole(keccak256("MINTER_ROLE"), address(CREATE_CODE));
        MONEY_POOL.setController(address(PO5));    
        PO5.SetProduct(address(PRODUCT));
        ORDER1.initialize(address(PRODUCT));
        PO5.setNSX(NSX);
        PO5.SetNftPos(address(NFTPOS));
        PO5.SetPOS(POS);
        PRODUCT.SetPOS(POS);
        NFTPOS.setController(address(PO5));
        CREATE_CODE.SetMining(address(MINING));
        CREATE_CODE.SetCodePool(address(MINING));
        vm.stopPrank();
        Register();
    }

    function mintUSDT(address user, uint256 amount) internal {
        vm.startPrank(Deployer);
        USDT_ERC.mintToAddress(user, amount * ONE_USDT);
        USDT_ERC.approve(address(PO5),amount * ONE_USDT);
        vm.stopPrank();
    }
    function Register() public {
        // 7 user need 7 * 160$ to register 12 month
        mintUSDT(Deployer,800*160);
        // Account 1 == A
        vm.startPrank(Deployer);
        bytes32 codeRef1;
        PO5.Register(codeRef1, codeRef1, 1, keccak256(abi.encodePacked(block.timestamp + 1)), address(0x1));
        vm.stopPrank();
        vm.startPrank(address(0x1));
        codeRef1 = PO5.GetCodeRef();
        vm.stopPrank();
    

        // Account 2 == B
        vm.startPrank(Deployer);
        PO5.Register(codeRef1, codeRef1, 1, keccak256(abi.encodePacked(block.timestamp + 2)), address(0x2));
        vm.stopPrank();
        vm.startPrank(address(0x2));
        bytes32 codeRef2 = PO5.GetCodeRef();
        vm.stopPrank();

        // Account 3 == C
        vm.startPrank(Deployer);
        PO5.Register(codeRef1, codeRef1, 1, keccak256(abi.encodePacked(block.timestamp + 3)), address(0x3));
        vm.stopPrank();
        vm.startPrank(address(0x3));
        bytes32 codeRef3 = PO5.GetCodeRef();
        vm.stopPrank();


        // Account 4 == D
        vm.startPrank(Deployer);
        PO5.Register(codeRef1, codeRef1, 1, keccak256(abi.encodePacked(block.timestamp + 4)), address(0x4));
        vm.stopPrank();
        vm.startPrank(address(0x4));
        bytes32 codeRef4 = PO5.GetCodeRef();
        vm.stopPrank();

        // Account 5 == E
        vm.startPrank(Deployer);
        PO5.Register(codeRef1, codeRef1, 1, keccak256(abi.encodePacked(block.timestamp + 5)), address(0x5));
        vm.startPrank(address(0x5));
        bytes32 codeRef5 = PO5.GetCodeRef();
        vm.stopPrank();

        // Account 6 == F
        vm.startPrank(Deployer);
        PO5.Register(codeRef1, codeRef2, 1, keccak256(abi.encodePacked(block.timestamp + 6)), address(0x6));
        vm.startPrank(address(0x6));
        bytes32 codeRef6 = PO5.GetCodeRef();
        vm.stopPrank();

     

        // Account 7 == G
        vm.startPrank(Deployer);
        PO5.Register(codeRef1, codeRef2, 1, keccak256(abi.encodePacked(block.timestamp + 7)), address(0x7));
        vm.stopPrank();
        vm.startPrank(address(0x7));
        // bytes32 codeRef7 = PO5.GetCodeRef();
        vm.stopPrank();

        // Account 8 == H
        vm.startPrank(Deployer);
        PO5.Register(codeRef1, codeRef3, 1, keccak256(abi.encodePacked(block.timestamp + 8)), address(0x8));
        vm.stopPrank();
        vm.startPrank(address(0x8));
        // bytes32 codeRef8 = PO5.GetCodeRef();
        vm.stopPrank();

        // Account 9 == I
        vm.startPrank(Deployer);
        PO5.Register(codeRef1, codeRef4, 1, keccak256(abi.encodePacked(block.timestamp + 9)), address(0x9));
        vm.stopPrank();
        vm.startPrank(address(0x9));
        bytes32 codeRef9 = PO5.GetCodeRef();
        vm.stopPrank();

        // Account 10 == K
        vm.startPrank(Deployer);
        PO5.Register(codeRef1, codeRef5, 1, keccak256(abi.encodePacked(block.timestamp + 10)), address(0x10));
        vm.stopPrank();
        vm.startPrank(address(0x10));
        bytes32 codeRef10 = PO5.GetCodeRef();
        vm.stopPrank();

        // Account 11 == L
        // vm.startPrank(Deployer);
        // PO5.Register(codeRef1, codeRef5, 1, keccak256(abi.encodePacked(block.timestamp + 11)), address(0x11));
        // vm.stopPrank();
        // vm.startPrank(address(0x11));
        // bytes32 codeRef11 = PO5.GetCodeRef();
        // vm.stopPrank();

        // Account 12 == M
        vm.startPrank(Deployer);
        PO5.Register(codeRef1, codeRef5, 1, keccak256(abi.encodePacked(block.timestamp + 12)), address(0x12));
        vm.stopPrank();
        vm.startPrank(address(0x12));
        // bytes32 codeRef12 = PO5.GetCodeRef();
        vm.stopPrank();

        // Account 13 == N
        vm.startPrank(Deployer);
        PO5.Register(codeRef1, codeRef6, 1, keccak256(abi.encodePacked(block.timestamp + 13)), address(0x13));
        vm.stopPrank();
        vm.startPrank(address(0x13));
        // bytes32 codeRef13 = PO5.GetCodeRef();
        vm.stopPrank();

        // Account 14 == O
        vm.startPrank(Deployer);
        PO5.Register(codeRef1, codeRef9, 1, keccak256(abi.encodePacked(block.timestamp + 14)), address(0x14));
        vm.stopPrank();
        vm.startPrank(address(0x14));
        // bytes32 codeRef14 = PO5.GetCodeRef();
        vm.stopPrank();

        // Account 15 == P
        vm.startPrank(Deployer);
        PO5.Register(codeRef1, codeRef10, 1, keccak256(abi.encodePacked(block.timestamp + 15)), address(0x15));
        vm.stopPrank();
        vm.startPrank(address(0x15));
        // bytes32 codeRef15 = PO5.GetCodeRef();
        vm.stopPrank();

        // Account 16 == Q
        // vm.startPrank(Deployer);
        // PO5.Register(codeRef1, codeRef11, 1, keccak256(abi.encodePacked(block.timestamp + 16)), address(0x16));
        // vm.stopPrank();
        // vm.startPrank(address(0x16));
        // // bytes32 codeRef16 = PO5.GetCodeRef();
        // vm.stopPrank();

        // Account 17 == R
        vm.startPrank(Deployer);
        PO5.Register(codeRef1, codeRef1, 1, keccak256(abi.encodePacked(block.timestamp + 17)), address(0x17));
        vm.stopPrank();
        vm.startPrank(address(0x17));
        bytes32 codeRef17 = PO5.GetCodeRef();
        vm.stopPrank();

        // Account 18 == S
        vm.startPrank(Deployer);
        PO5.Register(codeRef1, codeRef1, 1, keccak256(abi.encodePacked(block.timestamp + 18)), address(0x18));
        vm.stopPrank();
        vm.startPrank(address(0x18));
        // bytes32 codeRef18 = PO5.GetCodeRef();
        vm.stopPrank();

        // Account 19 == T
        vm.startPrank(Deployer);
        PO5.Register(codeRef1, codeRef1, 1, keccak256(abi.encodePacked(block.timestamp + 19)), address(0x19));
        vm.stopPrank();
        vm.startPrank(address(0x19));
        // bytes32 codeRef19 = PO5.GetCodeRef();
        vm.stopPrank();

        // Account 20 == U
        vm.startPrank(Deployer);
        PO5.Register(codeRef1, codeRef17, 1, keccak256(abi.encodePacked(block.timestamp + 20)), address(0x20));
        vm.stopPrank();
        vm.startPrank(address(0x20));
        bytes32 codeRef20 = PO5.GetCodeRef();
        vm.stopPrank();

        // Account 21 == V
        vm.startPrank(Deployer);
        PO5.Register(codeRef1, codeRef17, 1, keccak256(abi.encodePacked(block.timestamp + 21)), address(0x21));
        vm.stopPrank();
        vm.startPrank(address(0x21));
        // bytes32 codeRef21 = PO5.GetCodeRef();
        vm.stopPrank();

        // Account 22 == W
        vm.startPrank(Deployer);
        PO5.Register(codeRef1, codeRef20, 1, keccak256(abi.encodePacked(block.timestamp + 22)), address(0x22));
        vm.stopPrank();
        vm.startPrank(address(0x22));
        bytes32 codeRef22 = PO5.GetCodeRef();
        vm.stopPrank();

        // Account 23 == Y
        vm.startPrank(Deployer);
        PO5.Register(codeRef1, codeRef20, 1, keccak256(abi.encodePacked(block.timestamp + 23)), address(0x23));
        vm.stopPrank();
        vm.startPrank(address(0x23));
        // bytes32 codeRef23 = PO5.GetCodeRef();
        vm.stopPrank();

        // Account 24 == Z
        vm.startPrank(POS);
        bytes memory callData = PO5.GetCallData(PO5.CallData(codeRef1, codeRef22, 1, address(0x24)),KVenture.ExecuteOrderType.Register);
        PO5.ExecuteOrder(
            callData,
            0x0000000000000000000000000000000000000000000000000000000000000002,
            60 * ONE_USDT);
        //
        callData = PO5.GetCallData(PO5.CallData(codeRef1, codeRef22, 1, address(0x24)),KVenture.ExecuteOrderType.Paysub);
        PO5.ExecuteOrder(
            callData,
            0x0000000000000000000000000000000000000000000000000000000000000002,
            60 * ONE_USDT);

        vm.stopPrank();
        vm.startPrank(address(0x24));
        // bytes32 codeRef24 = PO5.GetCodeRef();
       
        vm.stopPrank();

        // Account 25 == 1
        vm.startPrank(Deployer);
        PO5.Register(codeRef1, codeRef3, 1, keccak256(abi.encodePacked(block.timestamp + 25)), address(0x25));
        vm.stopPrank();
        vm.startPrank(address(0x25));
        // bytes32 codeRef25 = PO5.GetCodeRef();
        vm.stopPrank();
        callData = PO5.GetCallData(
            PO5.CallData(
            bytes32(0),
            0x00d5572d2de7b1afa8c786a5283023b0f9380e6cf76153e2fd996077f594327b, 
            1, 
            0x391fFF8136E5066668F254F2bF074e5dAc318867),
            KVenture.ExecuteOrderType.Register
        );
        bytes memory bytesCodeCall = abi.encodeCall(
        PO5.ExecuteOrder,
        ( 
        callData,
        0x0000000000000000000000000000000000000000000000000000000000000002,
        60 * ONE_USDT));

        console.log("registerLock bytecode: ");
        console.logBytes(bytesCodeCall);
        console.log(
            "-----------------------------------------------------------------------------"
        );
        bytesCodeCall = abi.encodeCall(
        PO5.USDTLock,
        ()
        );
        console.log("nftPos bytecode: ");
        console.logBytes(bytesCodeCall);
        console.log(
            "-----------------------------------------------------------------------------"
        );
        bytesCodeCall = abi.encodeCall(
        PO5.GetRefCoder,
        0xB50b908fFd42d2eDb12b325e75330c1AaAf35dc0
        );
        console.log("SetNftPos bytecode: ");
        console.logBytes(bytesCodeCall);
        console.log(
            "-----------------------------------------------------------------------------"
        );

    }

    function testOrder()public{
        //admin add product
        vm.startPrank(Deployer);
        PRODUCT.SetAdmin(Deployer);
        USDT_ERC.burnByOwner(MAX_OUT, USDT_ERC.balanceOf(MAX_OUT));
        USDT_ERC.burnByOwner(MTN, USDT_ERC.balanceOf(MTN));
        USDT_ERC.burnByOwner(DAO_DT, USDT_ERC.balanceOf(DAO_DT));
        Product [] memory ProductArr = new Product[](1);

        // PRODUCT.adminAddProduct("100",100*ONE_USDT,117*ONE_USDT,"ao",true,120);
        PRODUCT.AdminAddProduct("100_000",100_000*ONE_USDT,120_077*ONE_USDT,"ao","100_000",true,120,27_444*ONE_USDT,200_000*ONE_USDT);
        ProductArr = PRODUCT.AdminViewProduct();
        vm.stopPrank();
        //case1:
        vm.startPrank(POS);
        // address L order 1 products 100_000
        OrderInput[] memory orders = new OrderInput[](1);
        // address L order 1 products 100_000
        bytes32[] memory codeHash0L = new bytes32[](1);
        // codeHash0L= getCodeHash(1,100_000);     
        codeHash0L[0] = 0x000000000000000000000000000000000000000000000000000000000000000c;
        bytes32 idPayment =  0x0000000000000000000000000000000000000000000000000000000000000001 ;
        OrderInput memory input = OrderInput({
            id        : ProductArr[0].id,
            quantity  : 1,
            lock      : true,
            codeHashes: codeHash0L,
            delegate  : address(0)
        }); 
        OrderInput[] memory orderLockInputs = new OrderInput[](1);
        orderLockInputs[0]= input;
        bytes memory callData = PRODUCT.CallData(
            orderLockInputs,
            address(0x24)
        );
        uint256 paymentAmount = 120_077*ONE_USDT;
        PRODUCT.ExecuteOrder(callData,idPayment,paymentAmount);
        console.log("NSX:",USDT_ERC.balanceOf(NSX));
        console.log("MAX_OUT:",USDT_ERC.balanceOf(MAX_OUT));
        console.log("MTN:",USDT_ERC.balanceOf(MTN));
        console.log("DAO:",USDT_ERC.balanceOf(DAO_DT));
        console.log("TotalGoodSaleBonus W:",PO5.totalRevenues(address(0x22))); 
        console.log(PO5.ranks(PO5.lineMatrix(address(0x22))));
        console.log("--------------------------------------");
        console.log("NSX:",NFTPOS.balanceOf(NSX,uint256(idPayment)));
        console.log("MAX_OUT:",NFTPOS.balanceOf(MAX_OUT,uint256(idPayment)));
        console.log("MTN:",NFTPOS.balanceOf(MTN,uint256(idPayment)));
        console.log("DAO:",NFTPOS.balanceOf(DAO_DT,uint256(idPayment)));
        console.log("address(0x22) W:",NFTPOS.balanceOf(address(0x22),uint256(idPayment))); 
        console.log("--------------------------------------");
        KVenture.UserInfo memory userinfo = PO5.GetUserInfo(address(0x22));
        console.log("totalSubcriptionBonus:",userinfo.totalSubcriptionBonus);
        console.log("totalMatrixBonus:",userinfo.totalMatrixBonus);
        console.log("totalMatchingBonus:",userinfo.totalMatchingBonus);
        console.log("totalSaleBonus",userinfo.totalSaleBonus);
        console.log("totalGoodSaleBonus:",userinfo.totalGoodSaleBonus);
        console.log("totalGoodSaleBonusLock:",userinfo.totalGoodSaleBonusLock);
        console.log("totalMatchingBonusLock:",userinfo.totalMatchingBonusLock);

        vm.stopPrank();
        console.log(
            "-----------------------------------------------------------------------------"
        );
        // OrderInput[] memory orders1 = new OrderInput[](1);
        orderLockInputs = new OrderInput[](1);
        address buyer = 0x83CEC343cFc7A6644C1547277d26D7A621FDc40C;
        OrderInput memory input1 = OrderInput({
            id        : 0x1880f7dce7af58e012be596637fec2ebc3000e8aeb4a8ed6fe3764800cec091b,
            quantity  : 1,
            lock      : true,
            codeHashes: codeHash0L,
            delegate  : 0x443661EcD006aFdC75F1366276A53860f15e23C5
        }); 
        orderLockInputs[0] = input1;        
        callData = PRODUCT.CallData(
            orderLockInputs,
            buyer
        );
        bytes memory bytesCodeCall = abi.encodeCall(
        PRODUCT.ExecuteOrder,
        (callData,
        idPayment,
        paymentAmount
        ));
        console.log("orderLock bytecode: ");
        console.logBytes(bytesCodeCall);
        console.log(
            "-----------------------------------------------------------------------------"
        );
    }
    function getCodeHash(uint256 amount,uint256 price) public pure returns(bytes32[] memory){
        bytes32[] memory codeHashArr = new bytes32[](amount);
        for (uint i=0;i< amount;i++){
            codeHashArr[i]= keccak256(abi.encodePacked(i+amount+price));
        }
        return codeHashArr;
    }
}
