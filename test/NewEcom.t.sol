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

contract NewEcom is Test {
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

    function test_createUser() public {
        vm.prank(address(1));
        registerParams memory params =registerParams({
                fullName: "hehe",
                email: "hehe@gmail.com",
                gender: 1,
                dateOfBirth: block.timestamp,
                phoneNumber: "0909090909"
            });
        createUser();

        vm.prank(address(1));
        (UserInfo memory user, ) = EcomUser.getUser();
        assertEq(user.fullName, params.fullName);
    }

    function seeds() internal {
        seedCategories(5);
        seedProducts(10);
    }

    function internalTest() internal view{
        Product[] memory products = EcomProduct.getProducts();
        assertEq(products.length, 10);
    }

    function test_haha() public {
        seeds();
        internalTest();
    }

    function test_createSameAttributes() public {
        seedCategories(5);

        createProductParams memory params;
        params.name = "Test Product ";
        params.categoryID = 1;
        params.retailer =  Retailer1;

        // Expect revert due to duplicate variant attributes
        vm.expectRevert('{"from": "EcomProduct.sol","code": 60, "message": "Duplicate variant attributes detected"}');
        vm.prank(Controller);
        uint256 productId = EcomProduct.createProduct(params,createVariantsWithSameAttributes(2));
        assertEq(productId,0);
    }

    function test_updateProduct() public {
        seeds();
        
        vm.prank(Controller);

        createProductParams memory newParams = createProductParams({
            name: "Updated Product Name",
            categoryID: 2, // Assuming this categoryID exists
            description: "Updated Description",
            shippingFee: 1000,
            retailer: Retailer1,
            brandName: "Updated Brand",
            warranty: "2 years",
            isFlashSale: false,
            images: new bytes[](0) , // Assuming empty for simplicity
            videoUrl: "https://updated-video-url.com",
            isApprove: true,
            sold: 200,
            boostTime: 0,
            expiryTime: 0,
            flashSaleExpiryTime: 0,
            activateTime: 0,
            isMultipleDiscount: true
        });

        // Call the updateProduct function with newParams and some updated variants
        VariantParams[] memory updatedVariants = new VariantParams[](1);
        Attribute[] memory data = new Attribute[](1);
        data[0] = Attribute({
            id: "",
            key: "Color",
            value: "Blue"
        });
        bytes32 hash = hashAttributes(data);

        updatedVariants[0] = VariantParams({
            variantID: hash,
            attrs: data,
            priceOptions: Pricing({
                retailPrice: 1500,
                vipPrice: 1200,
                memberPrice: 1100,
                reward: 100,
                quantity: 50
            })
        });

        bool updateSuccess = EcomProduct.updateProduct(8, newParams, updatedVariants);

        ProductInfo memory info = EcomProduct.getProductInfo(8);

        assertTrue(updateSuccess, "Product update should succeed");
        assertEq(info.product.params.name, "Updated Product Name", "Product name should be updated");
        assertEq(info.product.params.categoryID, 2, "Category ID should be updated");
        assertEq(info.product.params.description, "Updated Description", "Product description should be updated");
        assertEq(info.product.params.brandName, "Updated Brand", "Product brand name should be updated");
        assertEq(info.product.params.videoUrl, "https://updated-video-url.com", "Video URL should be updated");
        assertEq(info.product.params.isMultipleDiscount, true, "isMultipleDiscount should be updated");

        assertEq(info.variants.length, 1, "There should be one updated variant");
        assertEq(info.variants[0].variantID, hash, "Variant ID should be updated");

        assertEq(info.attributes[0].length, 1, "There should be one attribute for the variant");
        assertEq(info.attributes[0][0].key, "Color", "Attribute key should be updated");
        assertEq(info.attributes[0][0].value, "Blue", "Attribute value should be updated");

        assertEq(info.variants[0].priceOptions.retailPrice, 1500, "Retail price should be updated");
        assertEq(info.variants[0].priceOptions.vipPrice, 1200, "VIP price should be updated");
        assertEq(info.variants[0].priceOptions.memberPrice, 1100, "Member price should be updated");
        assertEq(info.variants[0].priceOptions.reward, 100, "Reward should be updated");
        assertEq(info.variants[0].priceOptions.quantity, 50, "Quantity should be updated");
    }

    function test_updateProductImages() public {
        seeds();
        bytes[] memory newImages = new bytes[](2);
        newImages[0] = "image1.png";
        newImages[1] = "image2.png";
        vm.prank(Retailer1);
        bool success = EcomProduct.updateProductImages(8,newImages);
        Product memory product = EcomProduct.getProduct(8);
        assertEq(product.params.images[0],newImages[0]);
        assertEq(product.params.images[1], newImages[1]);
    }


    function test_deleteProduct() public{
        seeds();
        vm.prank(Controller);
        bool success = EcomProduct.deleteProduct(8);
        ProductInfo memory info = EcomProduct.getProductInfo(8);
        Product[] memory retailerProducts = EcomProduct.getRetailerProduct(Retailer1);
        bool productDeleted = true;
        for (uint256 i = 0; i < retailerProducts.length; i++) {
            if (retailerProducts[i].id == 8) {
                productDeleted = false;
                break;
            }
        }
        assertTrue(info.variants.length == 0);
        assertTrue(info.attributes.length == 0);
        assertTrue(success);
        assertTrue(productDeleted, "Product with ID 8 should not exist in the retailer's product list");
    }

    function test_addToCart() public {
        seeds();
        ProductInfo memory info = EcomProduct.getProductInfo(8);
        uint256 quantity = 5;
        address User1 = address(4554);
        vm.startPrank(User1);
        CartItem memory item = EcomOrder.addItemToCart(info.product.id, info.variants[1].variantID, quantity);

        Cart memory cart = EcomOrder.getUserCart();
        vm.stopPrank();
        assertTrue(cart.id > 0);
        assertTrue(User1 == cart.owner);
        assertTrue(cart.items[0].productID == info.product.id);
        assertTrue(cart.items[0].variantID == info.variants[1].variantID);
        assertTrue(cart.items[0].quantity == quantity);
    }
    function test_addMultipleItemsToCart()public{
        seeds();
        ProductInfo memory info = EcomProduct.getProductInfo(8);
        ProductInfo memory info1 = EcomProduct.getProductInfo(1);
        uint256 totalData = 3;
        address User1 = address(4554);
        AddItemToCartParams[] memory params = new AddItemToCartParams[](totalData);

        params[0]._productID = info.product.id;
        params[0]._variantID = info.variants[2].variantID;
        params[0].quantity = 5;

        params[1]._productID = info.product.id;
        params[1]._variantID = info.variants[3].variantID;
        params[1].quantity = 15;

        params[2]._productID = info.product.id;
        params[2]._variantID = info.variants[0].variantID;
        params[2].quantity = 20;

        vm.startPrank(User1);
        CartItem[] memory item = EcomOrder.addItemsToCart(params);

        Cart memory cart = EcomOrder.getUserCart();
        vm.stopPrank();
        assertTrue(cart.id > 0);
        assertTrue(User1 == cart.owner);
        assertTrue(cart.items.length == totalData); // Ensure multiple items were added

        for (uint i = 0; i < totalData; i++) {
            assertTrue(cart.items[i].productID == params[i]._productID);
            assertTrue(cart.items[i].variantID == params[i]._variantID);
            assertTrue(cart.items[i].quantity == params[i].quantity);
        }

    }

    function test_deleteCart() public{
        seeds();
    
        ProductInfo memory info = EcomProduct.getProductInfo(8);
        uint256 quantity = 5;
        address User1 = address(4554);

        vm.startPrank(User1);

        CartItem memory item1 = EcomOrder.addItemToCart(info.product.id, info.variants[1].variantID, quantity);
        CartItem memory item2 = EcomOrder.addItemToCart(info.product.id, info.variants[2].variantID, quantity);

        Cart memory cart = EcomOrder.getUserCart();
        assertTrue(cart.id > 0);
        assertTrue(User1 == cart.owner);

        uint256[] memory itemIds = new uint256[](2);
        itemIds[0] = item1.id;
        itemIds[1] = item2.id;

        bool success = EcomOrder.deleteItemsInCart(itemIds);
        assertTrue(success);

        Cart memory updatedCart = EcomOrder.getUserCart();
        assertTrue(updatedCart.items.length == 0);

        vm.stopPrank();
    }

    function test_deleteItemToCart()public{
        seeds();

        ProductInfo memory info = EcomProduct.getProductInfo(8);
        uint256 quantity = 5;
        address User1 = address(4554);

        vm.startPrank(User1);

        // Add multiple items to cart
        EcomOrder.addItemToCart(info.product.id, info.variants[1].variantID, quantity);
        CartItem memory item2 = EcomOrder.addItemToCart(info.product.id, info.variants[2].variantID, quantity);
        EcomOrder.addItemToCart(info.product.id, info.variants[3].variantID, quantity);

        Cart memory cart = EcomOrder.getUserCart();
        assertTrue(cart.id > 0);
        assertTrue(User1 == cart.owner);
        assertTrue(cart.items.length == 3); 

        EcomOrder.deleteItemInCart(item2.id);

        // Check if items have been removed
        Cart memory updatedCart = EcomOrder.getUserCart();
        assertTrue(updatedCart.items.length == 2); 

        vm.stopPrank();
    }

    function test_updateItemInCart() public {
        seeds();

        ProductInfo memory info = EcomProduct.getProductInfo(8);
        uint256 quantity = 5;
        address User1 = address(4554);
        
        vm.startPrank(User1);
        
        CartItem memory item = EcomOrder.addItemToCart(info.product.id, info.variants[1].variantID, quantity);
        
        uint256 newQuantity = 10;
        CartItem memory updatedItem = EcomOrder.updateItemInCart(item.id, newQuantity);
        
        Cart memory cart = EcomOrder.getUserCart();
        
        vm.stopPrank();

        assertTrue(cart.id > 0);
        assertTrue(User1 == cart.owner);
        assertEq(updatedItem.quantity, newQuantity);
        assertEq(updatedItem.id, item.id);
    }


    function test_updateMultipleItemsInCart() public {
        seeds(); 

        ProductInfo memory info = EcomProduct.getProductInfo(8);
        ProductInfo memory info1 = EcomProduct.getProductInfo(1);
        address User1 = address(4554);
        vm.startPrank(User1);

        // Add multiple items to the cart
        EcomOrder.addItemToCart(info.product.id, info.variants[2].variantID, 5);
        EcomOrder.addItemToCart(info.product.id, info.variants[3].variantID, 15);
        EcomOrder.addItemToCart(info1.product.id, info1.variants[0].variantID, 20);

        uint256 totalItems = 3;
        UpdateItemsToCartParams[] memory params = new UpdateItemsToCartParams[](totalItems);

        params[0].itemID = 1; 
        params[0].quantity = 10;

        params[1].itemID = 2;
        params[1].quantity = 20;

        params[2].itemID = 3;
        params[2].quantity = 25;

        CartItem[] memory updatedItems = EcomOrder.updateItemsToCart(params);

        Cart memory cart = EcomOrder.getUserCart();
        
        vm.stopPrank();

        // Assertions
        assertTrue(cart.id > 0);
        assertTrue(User1 == cart.owner);

        assertEq(updatedItems[0].quantity, 10);
        assertEq(updatedItems[1].quantity, 20);
        assertEq(updatedItems[2].quantity, 25);

        assertEq(updatedItems[0].id, 1);
        assertEq(updatedItems[1].id, 2);
        assertEq(updatedItems[2].id, 3);
    }

    function test_updateItemsInCart_ItemNotFound() public {
        seeds();

        address User1 = address(4554);
        vm.startPrank(User1);

        ProductInfo memory info = EcomProduct.getProductInfo(8);
        EcomOrder.addItemToCart(info.product.id, info.variants[2].variantID, 5);

        UpdateItemsToCartParams[] memory params = new UpdateItemsToCartParams[](1);
        params[0].itemID = 9999; // Assumed to be an invalid item ID
        params[0].quantity = 10;

        vm.expectRevert('{"from": "EcomOrder.sol","code": 9, "message": "Item not found in cart"}');
        EcomOrder.updateItemsToCart(params);

        vm.stopPrank();
    }

    function test_updateItemsInCart_InsufficientQuantity() public {
        seeds(); // Seed data for testing

        address User1 = address(4554);
        vm.startPrank(User1);

        ProductInfo memory info = EcomProduct.getProductInfo(8);
        EcomOrder.addItemToCart(info.product.id, info.variants[2].variantID, 5);

        // Create update parameters with a quantity exceeding available stock
        UpdateItemsToCartParams[] memory params = new UpdateItemsToCartParams[](1);

        params[0].itemID = 1;
        params[0].quantity = 10000; // Assumed to exceed stock

        // Attempt to update the item, should revert
        vm.expectRevert('{"from": "EcomOrder.sol","code": 8, "message": "Insufficient quantity available for purchase"}');
        EcomOrder.updateItemsToCart(params);

        vm.stopPrank();
    }

    function test_createListTrackUser() public {
        seedCategories(10);
        seedProducts(20);

        uint256[] memory params1 = new uint256[](3);
        uint256[] memory params2 = new uint256[](3);
        uint256[] memory params3 = new uint256[](3);

        params1[0] = 1;
        params1[1] = 2;
        params1[2] = 3;

        params2[0] = 4;
        params2[1] = 5;
        params2[2] = 6;

        params3[0] = 7;
        params3[1] = 8;
        params3[2] = 9;

        EcomInfo.createListTrackUser(
            createListTrackUserParams("order5", 1, address(0), params1, params1)
        );
        EcomInfo.createListTrackUser(
            createListTrackUserParams("order2", 1, address(1), params2, params2)
        );
        EcomInfo.createListTrackUser(
            createListTrackUserParams("order3", 1, address(2), params3, params3)
        );

        // Verify the listTrackUserSystem entries
        vm.prank(Sender);
        ListTrackUser[] memory systemList = EcomInfo.getListTrackUser();

        assertEq(systemList.length, 3);
        assertEq(systemList[0].orderID, "order5");
        assertEq(systemList[1].orderID, "order2");
        assertEq(systemList[2].orderID, "order3");

        // Verify that the retailers match the products
        for (uint i = 0; i < params1.length; i++) {
            Product memory product = EcomProduct.getProduct(params1[i]);
            vm.prank(product.params.retailer);
            ListTrackUser[] memory retailerList = EcomInfo
                .getListTrackUserRetailer();
            assertEq(retailerList[0].orderID, "order5");
        }

        for (uint i = 0; i < params2.length; i++) {
            Product memory product = EcomProduct.getProduct(params2[i]);
            vm.prank(product.params.retailer);
            ListTrackUser[] memory retailerList = EcomInfo
                .getListTrackUserRetailer();
            assertEq(retailerList[0].orderID, "order5");
        }

        for (uint i = 0; i < params3.length; i++) {
            Product memory product = EcomProduct.getProduct(params3[i]);
            vm.prank(product.params.retailer);
            ListTrackUser[] memory retailerList = EcomInfo
                .getListTrackUserRetailer();

            assertEq(retailerList[0].orderID, "order5");
        }
    }

    function test_deleteListTrackUser() public {
        seedCategories(10);
        seedProducts(20);

        uint256[] memory params1 = new uint256[](3);
        uint256[] memory params2 = new uint256[](3);
        uint256[] memory params3 = new uint256[](3);

        params1[0] = 1;
        params1[1] = 2;
        params1[2] = 3;

        params2[0] = 4;
        params2[1] = 5;
        params2[2] = 6;

        params3[0] = 7;
        params3[1] = 8;
        params3[2] = 9;

        EcomInfo.createListTrackUser(
            createListTrackUserParams("order5", 1, address(0), params1, params1)
        );
        EcomInfo.createListTrackUser(
            createListTrackUserParams("order2", 1, address(1), params2, params2)
        );
        EcomInfo.createListTrackUser(
            createListTrackUserParams("order3", 1, address(2), params3, params3)
        );

        // Verify the listTrackUserSystem entries
        EcomInfo.deleteListTrackUser("order5");

        vm.prank(Sender);
        ListTrackUser[] memory systemList2 = EcomInfo.getListTrackUser();

        for (uint i = 0; i < systemList2.length; i++) {
            assertNotEq(systemList2[i].orderID, "order5");
        }

    }

    function test_listTrackUserAdmin() public{
        seeds();
        addItemsToCart();
        seedFavorites();
        createListTrackUserForTest();
        vm.prank(Retailer1);
        (
            ListTrackUser[] memory _listTracks,
            uint256 _favorites,
            uint256 _addedToCarts,
            AddedToCartAndWishList[] memory _totalCartWishList
        ) = EcomInfo.getListTrackRetailer();
        // Assertions for Retailer1
        assertTrue(_listTracks.length > 0, "Retailer should have tracked users");
        assertEq(_favorites, 8, "Retailer should have 3 favorites");
        assertEq(_addedToCarts, 3, "Retailer should have 3 added to carts");

        vm.prank(Sender);
        (
            ListTrackUser[] memory _listTracks1,
            uint256 _favorites1,
            uint256 _addedToCarts1,
            AddedToCartAndWishList[] memory _totalCartWishList1,
            uint256[] memory _systemPurchases1
        ) = EcomInfo.getListTrackAdmin();
        // Assertions for Admin
        assertTrue(_listTracks1.length > 0, "Admin should have tracked users");
        assertEq(_favorites1, 8, "Admin should have 8 favorites (sum from seedFavorites)");
        assertEq(_addedToCarts1, 3, "Admin should have 3 added to carts");
    }


    function test_ExecuteOrderUSDT1() public{
        // How to execute an order?
        //  must have product
        seeds();
        //  Add product to cart, add to cart with productID and variantID
        address User1 = address(4554);
        // create the params
        uint256 totalPriceWithoutDiscount;
            (
            uint256[] memory productIds,
            bytes32[] memory variantIds,
            uint256[] memory quantities,
            uint256[] memory cartItemIds,
            uint256 totalPrice
        ) = getSomeParams();
        // Make the params for execute order
        ShippingParams memory shippingParams = generateShippingParams();

        CreateOrderParams[] memory orderParams = generateCreateOrderParams(
            productIds, variantIds, quantities, cartItemIds
        );
        orderDetails memory details = orderDetails(totalPriceWithoutDiscount, "refCode1234",CheckoutType.RECEIVE,PaymentType.METANODE);
        // mint money to this account to buy product
        mintMoneyForUser(User1, totalPrice);
        vm.prank(User1);
        uint256 orderID = EcomOrder.ExecuteOrderUSDT(orderParams, shippingParams, User1, details);
        // bytes memory bytesCall = abi.encodeCall(
        //         productContract.ExecuteOrderUSDT,
        //         (orderParams,shippingParams,User1, details)
        //     );
        //     console.log("Function name: executeOrderUSDT");
        //     console.log("bytesCodeCall: ");
        //     console.logBytes(bytesCall);
        //     console.log(
        //         "-----------------------------------------------------------------------------"
        //     );
        
        assertTrue(orderID > 0, "successfully purchase");
        Product memory product = EcomProduct.getProduct(1);
        Product memory product8 = EcomProduct.getProduct(8);
        // Success purchase
        assertTrue(product8.params.sold > 0);
        assertTrue(product.params.sold > 0);
        // Check totalPurchase, recentPurchase...
    }

    function test_executeOrder1_Lock() public {
        seeds();
        address User1 = address(4554);

        uint256 totalPriceWithoutDiscount;
            (
            uint256[] memory productIds,
            bytes32[] memory variantIds,
            uint256[] memory quantities,
            uint256[] memory cartItemIds,
            uint256 totalPrice
        ) = getSomeParams();
        // Make the params for execute order
        ShippingParams memory shippingParams = generateShippingParams();

        CreateOrderParams[] memory orderParams = generateCreateOrderParams(
            productIds, variantIds, quantities, cartItemIds
        );

        vm.startPrank(pos);
        bytes32 mockPaymentId = keccak256(abi.encodePacked("payment-id")); // Mock Payment Id (Real: Get From Pos Smart Contract)

        bool success = createOrderLock(
            User1,
            0,
            "refCode1234",
            orderParams,
            shippingParams,
            CheckoutType.RECEIVE,
            totalPrice,
            mockPaymentId
        );

        assertTrue(success, "execute order id");
        vm.stopPrank();
    }

     function createExecuteOrderForStorage() public {
        seeds();
        //  Add product to cart, add to cart with productID and variantID
        address User1 = address(4554);
        // create the params
        uint256 totalPriceWithoutDiscount;
            (
            uint256[] memory productIds,
            bytes32[] memory variantIds,
            uint256[] memory quantities,
            uint256[] memory cartItemIds,
            uint256 totalPrice
        ) = getSomeParams();
        // Make the params for execute order
        ShippingParams memory shippingParams = generateShippingParams();

        CreateOrderParams[] memory orderParams = generateCreateOrderParams(
            productIds, variantIds, quantities, cartItemIds
        );
        orderDetails memory details = orderDetails(
            totalPriceWithoutDiscount,
            "refCode1234",
            CheckoutType.STORAGE,
            PaymentType.METANODE
        );
        // mint money to this account to buy product
        mintMoneyForUser(User1, totalPrice);
        vm.prank(User1);
        uint256 orderID = EcomOrder.ExecuteOrderUSDT(orderParams, shippingParams, User1, details);
        assertTrue(orderID > 0, "successfully purchase");
    }

    function test_createShareLink() public{
        createExecuteOrderForStorage();
        address User1 = address(4554);

        // productIds: [8, 8, 1]
        // variantIds: [0x60b71898c12a6df937d2c799fc23c64863091adcfc4f15e9ef2568da00248378, 0xaddde307f940b0f9061fa13f0ff8beaeef91cc886aadc2a6f8d2e789b71d5f70, 0x9f2f15d57ffbd1b6b9cf8a8d52e9a501ef2e35907ff34c2306ee02ef828260e8]
        // quantities: [5, 15, 20]
        // prices: [310000000,191000000,308000000]
        Order memory order = EcomOrder.getOrder(1);
        vm.prank(User1);
        ShareLinkParams[] memory params = createSharelinkParams(order);

        uint256 sharelinkID = EcomOrder.createShareLink(params, 1);
        assertTrue(sharelinkID > 0, "greater than 0?");

        address User2 = address(4555);
        generateShippingParams();
        mintMoneyForUser(User2,99999999999);

        vm.prank(User2);
        uint256 shareLinkOrderID = EcomOrder.ExecuteOrderStorage(
            sharelinkID,
            User2,
            generateShippingParams(),
            PaymentType.METANODE
        );
        assertTrue(shareLinkOrderID > 0, "greater than 0?");
        vm.prank(User1);
        (Order[] memory _orders, ,) = EcomInfo.getOrderHistoryDetail();
        // assertTrue(false);
    }

    function test_updateShareLink() public {
        createExecuteOrderForStorage();
        address User1 = address(4554);

        // productIds: [8, 8, 1]
        // variantIds: [0x60b71898c12a6df937d2c799fc23c64863091adcfc4f15e9ef2568da00248378, 0xaddde307f940b0f9061fa13f0ff8beaeef91cc886aadc2a6f8d2e789b71d5f70, 0x9f2f15d57ffbd1b6b9cf8a8d52e9a501ef2e35907ff34c2306ee02ef828260e8]
        // quantities: [5, 15, 20]
        // prices: [308000000,188000000, 308000000]
        Order memory order = EcomOrder.getOrder(1);
        vm.prank(User1);
        ShareLinkParams[] memory params = createSharelinkParams(order);

        uint256 sharelinkID = EcomOrder.createShareLink(params, 1);
        assertTrue(sharelinkID > 0, "greater than 0?");
        ShareLink memory sharelink = EcomOrder.getShareLink(sharelinkID);
        // assertTrue(sharelink.ID < 0);

        ShareLinkParams[] memory updatedParams = new ShareLinkParams[](1);
        // ????
        updatedParams[0].productIds = new uint256[](2);
        updatedParams[0].quantities= new uint256[](2);
        updatedParams[0].variantIds = new bytes32[](2);
        updatedParams[0].prices = new uint256[](2);
        updatedParams[0].productIds[0] = 8;
        updatedParams[0].productIds[1] = 1;
        updatedParams[0].quantities[0] = 5;
        updatedParams[0].quantities[1] = 20;
        updatedParams[0].variantIds[0] = sharelink.params[0].variantIds[0];
        updatedParams[0].variantIds[1] = sharelink.params[0].variantIds[2];
        updatedParams[0].prices[0] = sharelink.params[0].prices[0] * 2;
        updatedParams[0].prices[1] = sharelink.params[0].prices[1] * 2;
        updatedParams[0].parentOrderID = order.orderID;
        // ????
        vm.prank(User1);
        bool success = EcomOrder.updateShareLink(
            sharelinkID,
            updatedParams,
            1
        );
        assertTrue(success);
        ShareLink memory sharelink2 = EcomOrder.getShareLink(sharelinkID);
        Order memory order1 = EcomOrder.getOrder(1);
        uint256 totalPrice;
        for (uint256 i = 0; i < sharelink2.params[0].prices.length; i++){
            totalPrice += sharelink2.params[0].prices[i] * sharelink2.params[0].quantities[i];
        }
        address User2 = address(4555);
        generateShippingParams();
        mintMoneyForUser(User2,totalPrice);

        vm.prank(User2);
        uint256 wtf = EcomOrder.ExecuteOrderStorage(
            sharelinkID,
            User2,
            generateShippingParams(),
            PaymentType.METANODE
        );
        Order memory order2 = EcomOrder.getOrder(2);
        assertTrue(order2.orderID > 0);
    }

     function test_filterByFlashSale() public {
                seedCategories(5);
        seedProductsForPagin(20);
        (ProductInfo[] memory info, bool isMore) = EcomProduct.getAllProductInfoPagination(
            getProductManagementParams({
                _productType: EProductType.FLASHSALE,
                _price: EPrice.ASC,
                _datePost: EDatePost.ASC,
                _status: EStatus.ALL,
                _retailer: address(0),
                _term: "",
                _from: 0,
                _to: 0,
                page: 0,
                perPage: 5
            })
        );

        for (uint256 i = 0; i < info.length; i++) {
            assertTrue(info[i].product.params.isFlashSale);
        }
        assertTrue(info.length > 0);
    }

    // Filter by NEWPRODUCT
    function test_filterByNewProduct() public {
        seedCategories(5);
        seedProductsForPagin(20);
        (ProductInfo[] memory info, bool isMore) = EcomProduct.getAllProductInfoPagination(
            getProductManagementParams({
                _productType: EProductType.NEWPRODUCT,
                _price: EPrice.ASC,
                _datePost: EDatePost.ASC,
                _status: EStatus.ALL,
                _retailer: address(0),
                _term: "",
                _from: 0,
                _to: 0,
                page: 0,
                perPage: 5
            })
        );

        for (uint256 i = 0; i < info.length; i++) {
            assertTrue(info[i].product.createdAt >= block.timestamp - 7 days);
        }
        assertTrue(info.length > 0);
    }
    
    function test_filterByTerm() public {
        seedCategories(5);
        seedProductsForPagin(20);
        string memory searchTerm = "Test Product";

        (ProductInfo[] memory info, bool isMore) = EcomProduct.getAllProductInfoPagination(
            getProductManagementParams({
                _productType: EProductType.ALL,
                _price: EPrice.ASC,
                _datePost: EDatePost.ASC,
                _status: EStatus.ALL,
                _retailer: address(0),
                _term: searchTerm,
                _from: 0,
                _to: 0,
                page: 0,
                perPage: 5
            })
        );
        bytes memory bytesCall = abi.encodeCall(
                EcomProduct.getAllProductInfoPagination,
                (getProductManagementParams({
                _productType: EProductType.ALL,
                _price: EPrice.DESC,
                _datePost: EDatePost.DESC,
                _status: EStatus.ALL,
                _retailer: address(0),
                _term: searchTerm,
                _from: 1724994136,
                _to: 1724994138,
                page: 0,
                perPage: 5
            }))
            );
            console.log("Function name: getAllProductInfo");
            console.log("bytesCodeCall: ");
            console.logBytes(bytesCall);
            console.log(
                "-----------------------------------------------------------------------------"
            );

        for (uint256 i = 0; i < info.length; i++) {
            assertTrue(Utils.contains(searchTerm,info[i].product.params.name));
        }
        assertTrue(info.length > 0);
    }

    function test_createProductAndCheckCategoryAttribute() public{
        seeds();
        createProductParams memory params;
        params.name = "Test Product haha";
        params.categoryID = 1;
        params.retailer = Retailer1;
        params.isApprove =  true;
        params.isFlashSale = false;
        vm.prank(Controller);
        EcomProduct.createProduct(params,createVariantsForCategory(1));

        createProductParams memory params1;
        params1.name = "Test Product hahaA";
        params1.categoryID = 1;
        params1.retailer = Retailer1;
        params1.isApprove =  true;
        params1.isFlashSale = false;
        vm.prank(Controller);
        EcomProduct.createProduct(params1,createVariantsForCategory(1));


        // bytes memory bytesCall = abi.encodeCall(
        //     productContract.createProduct,
        //     (params,createVariants(i))
        // );
        // console.log("Function name: createProduct");
        // console.log("bytesCodeCall: ");
        // console.logBytes(bytesCall);
        // console.log(
        //     "-----------------------------------------------------------------------------"
        // );
        Attribute[] memory attrs = EcomProduct.getAttributesByCategory(1);
        assertTrue(false);
    }
    // ======================================================================================
    function createUser() internal {
        registerParams memory params =registerParams({
                fullName: "hehe",
                email: "hehe@gmail.com",
                gender: 1,
                dateOfBirth: block.timestamp,
                phoneNumber: "0909090909"
            });

        bool success = EcomUser.register(params);
        assertTrue(success);
    }

    function createSharelinkParams(Order memory order) internal pure returns(ShareLinkParams[] memory){
        ShareLinkParams[] memory params = new ShareLinkParams[](1);
            params[0] = ShareLinkParams({
            productIds: order.productIds,
            variantIds: order.variantIds,
            quantities: order.quantities,
            prices: order.prices,
            parentOrderID: order.orderID
        });
        return params;
    }
    function createOrderLock(
        address user,
        uint256 totalPriceWithoutDiscount,
        bytes32 codeRef,
        CreateOrderParams[] memory params,
        ShippingParams memory shippingParams,
        CheckoutType checkoutType,
        uint256 totalPrice,
        bytes32 paymentID
    ) internal returns (bool) {
        orderDetails memory details = orderDetails(
          totalPriceWithoutDiscount,
          codeRef,
          checkoutType,
          PaymentType.VISA
        );

        bytes memory encode = EncodeParamsExecuteOrder(params, shippingParams, user, details);
        
        return EcomOrder.ExecuteOrder(
            encode,
            paymentID,
            totalPrice
        );
    }

    function EncodeParamsExecuteOrder(
        CreateOrderParams[] memory params,
        ShippingParams memory shippingParams,
        address user,
        orderDetails memory details
    ) public returns (bytes memory) {
        uint256 _data = EcomOrder.CreateParamsForExecuteOrder(params, shippingParams, user, details);
        return abi.encode(_data);
    }

    function generateCreateOrderParams(
        uint256[] memory productIds,
        bytes32[] memory variantIds,
        uint256[] memory quantities,
        uint256[] memory cartItemIds
    ) public pure returns (CreateOrderParams[] memory res){
        res = new CreateOrderParams[](productIds.length);
        for (uint256 i = 0; i < productIds.length; i++){
            res[i] = CreateOrderParams(productIds[i],
                quantities[i],
                variantIds[i],
                cartItemIds[i],
                new string[](0)
            );
        }
    }

    function generateShippingParams() public pure returns (ShippingParams memory) {
        ShippingParams memory shippingParams = ShippingParams({
            firstName: "First Name",
            lastName: "Last Name",
            email: "meta-node-ecomerce@example.com",
            country: "Viet Nam",
            city: "Ho Chi Minh",
            stateOrProvince: "Ho Chi Minh",
            postalCode: "10001",
            phone: "+1 (555) 123-4567",
            addressDetail: "123 Main Street"
        });

        return shippingParams;
    }
    function getSomeParams() internal returns (
        uint256[] memory productIds,
        bytes32[] memory variantIds,
        uint256[] memory quantities,
        uint256[] memory cartItemIds,
        uint256 totalPrice
    ){
        ProductInfo memory info = EcomProduct.getProductInfo(8);
        address User1 = address(4554);
        
        ProductInfo memory info1 = EcomProduct.getProductInfo(1);
        uint256 totalData = 3;
        AddItemToCartParams[] memory params = new AddItemToCartParams[](totalData);

        params[0]._productID = info.product.id;
        params[0]._variantID = info.variants[2].variantID;
        params[0].quantity = 5;

        params[1]._productID = info.product.id;
        params[1]._variantID = info.variants[3].variantID;
        params[1].quantity = 15;

        params[2]._productID = info1.product.id;
        params[2]._variantID = info1.variants[0].variantID;
        params[2].quantity = 20;
        vm.prank(User1);
        CartItem[] memory item = EcomOrder.addItemsToCart(params);
        // bytes memory bytesCall = abi.encodeCall(
        //         productContract.addItemsToCart,
        //         (params)
        //     );
        //     console.log("Function name: addItemsToCart");
        //     console.log("bytesCodeCall: ");
        //     console.logBytes(bytesCall);
        //     console.log(
        //         "-----------------------------------------------------------------------------"
        //     );
        totalPrice = 
        info.variants[2].priceOptions.vipPrice * params[0].quantity + 
        info.variants[3].priceOptions.vipPrice * params[1].quantity + 
        info1.variants[0].priceOptions.vipPrice * params[2].quantity;
        productIds = new uint256[](item.length);
        variantIds = new bytes32[](item.length);
        quantities = new uint256[](item.length);
        cartItemIds = new uint256[](item.length);
        for (uint256 i = 0; i < item.length; i++){
            productIds[i] = item[i].productID;
            variantIds[i] = item[i].variantID;
            quantities[i] = item[i].quantity;
            cartItemIds[i] = item[i].id;
        }
    }

    function createVariants(uint256 count) internal view returns (VariantParams[] memory result) {
        result = new VariantParams[](count);
        for (uint256 i = 0; i < count; i++) {
            // Assign unique attributes for this variant
            result[i].attrs = new Attribute[](2);
            result[i].priceOptions = createPricing(i);
            for (uint256 j = 0; j < result[i].attrs.length; j++) {
                result[i].attrs[j] = createAttribute(i * 100 + j);
            }
        }
    }

    function createPricing(uint256 i) internal view returns (Pricing memory pricing) {
        bool val = i % 2 == 0;
        pricing.retailPrice = 100 * ONE_USDT;
        if (val) {
            pricing.vipPrice = (308 + i) * ONE_USDT;
            pricing.memberPrice = ((2345 + i) * ONE_USDT) / 10;
            pricing.reward = ((5901 + i) * ONE_USDT) / 100;
        } else {
            pricing.vipPrice = (188 + i) * ONE_USDT;
            pricing.memberPrice = ((1435 + i) * ONE_USDT) / 10;
            pricing.reward = ((3522 + i) * ONE_USDT) / 100;
        }
        pricing.quantity = 200;
    }

    function createAttribute(uint256 i) internal pure returns (Attribute memory attr) {
        attr.key = string.concat("Key ", Strings.toString(i)); 
        attr.value = string.concat("Value ", Strings.toString(i)); 
    }

    function seedProducts(uint256 count) internal {
        for (uint256 i = 1; i <= count; i++){
            createProductParams memory params;
            params.name = string.concat("Test Product ", Strings.toString(i));
            params.categoryID = 1;
            params.retailer = Retailer1;
            params.isApprove =  true;
            params.isFlashSale = i%2 == 0 ? true : false;
            vm.prank(Controller);
            EcomProduct.createProduct(params,createVariants(i));

            // bytes memory bytesCall = abi.encodeCall(
            //     productContract.createProduct,
            //     (params,createVariants(i))
            // );
            // console.log("Function name: createProduct");
            // console.log("bytesCodeCall: ");
            // console.logBytes(bytesCall);
            // console.log(
            //     "-----------------------------------------------------------------------------"
            // );
        }
    }

    function seedCategories(uint count) internal {
        vm.startPrank(Sender);
        for (uint i = 0; i < count; i++) {
            string memory name = string.concat(
                "Category ",
                Strings.toString(i)
            );
            string memory description = string.concat(
                "Description for Category ",
                Strings.toString(i)
            );
            EcomProduct.createCategory(name, description);
        }
        vm.stopPrank();
    }

    function hashAttributes(Attribute[] memory attrs) internal pure returns(bytes32){
        bytes memory attributesHash;

        for (uint256 i = 0; i < attrs.length; i++){
            attributesHash = abi.encodePacked(attributesHash, attrs[i].key, attrs[i].value);
        }

        return keccak256(attributesHash);
    }

    function createVariantsWithSameAttributes(uint256 count) internal view returns (VariantParams[] memory) {
        VariantParams[] memory result = new VariantParams[](count);

        for (uint256 i = 0; i < count; i++) {
            result[i].attrs = new Attribute[](2);
            result[i].attrs[0] = createAttribute(0); // Same attribute for all variants
            result[i].attrs[1] = createAttribute(1); // Same attribute for all variants
            result[i].priceOptions = createPricing(i);
        }

        return result;
    }

    function createVariantsForCategory(uint256 count) internal view returns (VariantParams[] memory) {
        VariantParams[] memory result = new VariantParams[](count);

        for (uint256 i = 0; i < count; i++) {
            result[i].attrs = new Attribute[](2);
            result[i].attrs[0] = Attribute("0", "haha", "hehe"); // Same attribute for all variants
            result[i].attrs[1] = Attribute("0", "hooh", "hii"); // Same attribute for all variants
            result[i].priceOptions = createPricing(i);
        }

        return result;
    }

    function seedFavorites()internal {
        vm.startPrank(address(0x999999));
        EcomProduct.createFavorite(1);
        EcomProduct.createFavorite(2);
        EcomProduct.createFavorite(3);
        EcomProduct.createFavorite(4);
        EcomProduct.createFavorite(5);
        vm.stopPrank();
        vm.startPrank(address(0x999998));
        EcomProduct.createFavorite(3);
        EcomProduct.createFavorite(4);
        EcomProduct.createFavorite(5);
        vm.stopPrank();
    }
    // helper function to fast add many data to cart;
    function addItemsToCart() internal {
        ProductInfo memory info = EcomProduct.getProductInfo(8);
        uint256 quantity = 5;
        address User1 = address(4554);
        
        ProductInfo memory info1 = EcomProduct.getProductInfo(1);
        uint256 totalData = 3;
        AddItemToCartParams[] memory params = new AddItemToCartParams[](totalData);

        params[0]._productID = info.product.id;
        params[0]._variantID = info.variants[2].variantID;
        params[0].quantity = 5;

        params[1]._productID = info.product.id;
        params[1]._variantID = info.variants[3].variantID;
        params[1].quantity = 15;

        params[2]._productID = info1.product.id;
        params[2]._variantID = info1.variants[0].variantID;
        params[2].quantity = 20;

        vm.startPrank(User1);
        CartItem[] memory item = EcomOrder.addItemsToCart(params);

        Cart memory cart = EcomOrder.getUserCart();
        vm.stopPrank();
    }

    function createListTrackUserForTest() internal{
        uint256[] memory params1 = new uint256[](3);
        uint256[] memory params2 = new uint256[](3);
        uint256[] memory params3 = new uint256[](3);

        params1[0] = 1;
        params1[1] = 2;
        params1[2] = 3;

        params2[0] = 4;
        params2[1] = 5;
        params2[2] = 6;

        params3[0] = 7;
        params3[1] = 8;
        params3[2] = 9;

        EcomInfo.createListTrackUser(
            createListTrackUserParams("order5", 1, address(0), params1, params1)
        );
        EcomInfo.createListTrackUser(
            createListTrackUserParams("order2", 1, address(1), params2, params2)
        );
        EcomInfo.createListTrackUser(
            createListTrackUserParams("order3", 1, address(2), params3, params3)
        );
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

    function seedProductsForPagin(uint256 count) internal {
        for (uint256 i = 1; i <= count; i++){
            createProductParams memory params;
            params.name = string.concat("Test Product ", Strings.toString(i));
            params.categoryID = 1;
            params.retailer = Retailer1;
            params.isApprove = i%2 ==0  ? true : false;
            params.isFlashSale = i%2 == 0 ? true : false;
            vm.warp(i % 2 == 0 ? 1724982761 : 1693360361);
            vm.prank(Controller);
            EcomProduct.createProduct(params,createVariants(i));

            // bytes memory bytesCall = abi.encodeCall(
            //     productContract.createProduct,
            //     (params,createVariants(i))
            // );
            // console.log("Function name: createProduct");
            // console.log("bytesCodeCall: ");
            // console.logBytes(bytesCall);
            // console.log(
            //     "-----------------------------------------------------------------------------"
            // );
        }
    }
}
