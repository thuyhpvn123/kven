// // SPDX-License-Identifier: UNLICENSED
// pragma solidity 0.8.19;

// import {Test, console} from "forge-std/Test.sol";
// // pragma solidity 0.8.19;
// import "../contracts/interfaces/IEcomProduct.sol";
// import "@openzeppelin/contracts@v4.9.0/token/ERC20/IERC20.sol";
// import "../contracts/interfaces/IEcomCart.sol";
// import "../contracts/interfaces/IDiscount.sol";
// import "../node_modules/@openzeppelin/contracts/utils/Strings.sol";
// import {KventureCode} from "../contracts/GenerateCode.sol";
// import {PackageInfoStruct} from "../contracts/AbstractPackage.sol";
// import {MasterPool} from "../contracts/MasterPool.sol";
// import {USDT} from "../contracts/usdt.sol";
// import {BinaryTree} from "../contracts/BinaryTree.sol";
// import {KVenture} from "../contracts/kventure.sol";
// // import {CodePool} from "../contracts/codepool.sol";
// import {KProduct} from "../contracts/KvenProduct.sol";
// import {KOrder} from "../contracts/Order.sol";
// import {KventureNft} from "../contracts/PackageNFT.sol";
// import {Mining} from "../contracts/mocks/Mining.sol";
// import {ProductContract} from "../contracts/EcomProduct.sol";
// import {ERC1155Kven} from "../contracts/NFT1155.sol";
// import "../contracts/interfaces/INoti.sol";
// import {Notification} from "../contracts/mocks/Noti.sol";

// contract ProductContractTest is Test {
//     USDT public USDT_ERC;
//     // IERC20 public
//     KVenture public PO5;
//     ProductContract public productContract;
//     address public admin = address(this);
//     MasterPool public MONEY_POOL;
//     KventureCode public CREATE_CODE;
//     BinaryTree public TREE;
//     // CodePool public CODE_POOL;
//     KProduct public PRODUCT;
//     KOrder public ORDER;
//     KventureNft public NFT;
//     Mining public MINING;
//     Notification public NOTIFICATION;
//     ERC1155Kven public posNFT;

//     address public Deployer = address(0x1510);
//     address public Max_out = address(0x1661);
//     address public MTN = address(0x1771);
//     address public DTBH = address(0x1881);
//     address public DAO_DT = address(0x1551);
//     address public NSX = address(0x16969);
//     address public Noti = address(0x199999);
//     uint256 ONE_USDT = 1_000_000;
//     address public Controller = address(0x9999);

//     address Sender = address(0x123456);
//     address public Retailer1 = address(0x6969);
//     address public Retailer2 = address(this);
//     uint256 public EXISTS_USER = 3;

//     bytes32 refCode1 = "refCode1234";
//     bytes32 refCode2 = "refCode12345";
//     uint256 public TIME = 1910678047; // Friday, July 19, 2030 7:54:07 AM

//     function mintUSDT(address user, uint256 amount) internal {
//         vm.startPrank(Deployer);
//         USDT_ERC.mintToAddress(user, amount * ONE_USDT);
//         USDT_ERC.approve(address(PO5), amount * ONE_USDT);
//         vm.stopPrank();
//     }

//     address public pos = address(300);

//     function setUp() public {
//         vm.startPrank(Sender);
//         productContract = new ProductContract();
//         PO5 = new KVenture();
//         USDT_ERC = new USDT();
//         MONEY_POOL = new MasterPool(address(USDT_ERC));
//         TREE = new BinaryTree(address(PO5));
//         CREATE_CODE = new KventureCode();
//         NOTIFICATION = new Notification();
//         productContract.SetKven(address(PO5));
//         productContract.SetMasterPool(address(MONEY_POOL));
//         productContract.SetController(Controller);
//         productContract.SetPos(pos);

//         PO5.initialize(
//             address(USDT_ERC),
//             address(MONEY_POOL),
//             address(TREE),
//             Deployer,
//             DAO_DT,
//             DTBH,
//             address(CREATE_CODE),
//             MTN,
//             Max_out,
//             Deployer
//         );

//         posNFT = new ERC1155Kven();
//         posNFT.setController(address(PO5));
//         PO5.SetNftPos(address(posNFT));

//         PO5.SetProduct(address(productContract));
//         productContract.SetUsdt(address(USDT_ERC));
//         productContract.SetNotification(address(NOTIFICATION));
//         MONEY_POOL.setController(address(PO5));
//         PO5.setNSX(NSX);

//         PO5.SetRefInfo("refCode123", address(0x5555));
//         PO5.SetRefInfo("refCode1234", address(0x2222));

//         // bytes32 codeRef1;
//         bytes32 codeRef2;
//         uint256 amount = 900 * 160;

//         USDT_ERC.mintToAddress(Sender, amount * ONE_USDT);
//         USDT_ERC.approve(address(PO5), amount * ONE_USDT);
//         PO5.Register(
//             "refCode",
//             codeRef2,
//             1,
//             keccak256(abi.encodePacked(block.timestamp + 1)),
//             Retailer1
//         );
//         vm.stopPrank();

//         vm.startPrank(Retailer1);
//         bytes32 senderCodeRef1 = PO5.GetCodeRef();
//         vm.stopPrank();

//         vm.startPrank(Sender);
//         USDT_ERC.mintToAddress(Sender, amount * ONE_USDT);
//         USDT_ERC.approve(address(PO5), amount * ONE_USDT);
//         PO5.Register(
//             "refCode",
//             senderCodeRef1,
//             1,
//             keccak256(abi.encodePacked(block.timestamp + 1)),
//             Retailer2
//         );
//         vm.stopPrank();

//         vm.prank(Retailer1);
//         productContract.registerRetailer("first", "first");
//         vm.prank(Retailer2);
//         productContract.registerRetailer("second", "second");
//     }

//     event eCreateCategory(uint256 id, string name, string description);
//     event eCreateProduct(uint256 id, createProductParams params);
//     event eCreateOrder(uint256 orderID);
//     event ESpendUsdt(
//         address indexed _to,
//         uint256 indexed _amount,
//         address indexed _receive,
//         bytes _input,
//         address[] _relatedAddresses
//     );
//     event eCreateShipping(
//         uint256 id,
//         uint256 orderID,
//         address userAddress,
//         string firstName,
//         string lastName,
//         string email,
//         string country,
//         string city,
//         string stateOrProvince,
//         string postalCode,
//         string phone,
//         string addressDetail
//     );

//     struct PairPrices {
//         uint256 fromPrice;
//         uint256 toPrice;
//     }
//     uint256 public currentTime = 31536001;

//     function test_CreateCategory() public {
//         (
//             string memory testName,
//             string memory testDescription,

//         ) = seedCategory();
//         // Expect the first category ID is 1
//         uint256 expectCategoryID = 1;

//         // Expect the eCreateCategory event to be emitted & log data
//         vm.expectEmit(true, true, true, true);
//         emit eCreateCategory(expectCategoryID, testName, testDescription);
//         vm.prank(Sender);
//         productContract.createCategory(testName, testDescription);

//         // Retrieve categories
//         Category memory category = productContract.getCategory(
//             expectCategoryID
//         );

//         // Verify the category details
//         assertEq(category.id, expectCategoryID);
//         assertEq(category.name, testName);
//         assertEq(category.description, testDescription);
//     }

//     function test_CreateCategoryRequireAdmin() public {
//         // vm.expectRevert(bytes("You are not allowed"));
//         (
//             string memory testName,
//             string memory testDescription,
//             string[] memory testUrls
//         ) = seedCategory();

//         vm.prank(Sender);
//         productContract.createCategory(testName, testDescription);
//     }

//     function test_CreateProduct() public {
//         uint256 expectProductID = 1;
//         createProductParams memory params = generateCreateProductParams(false);

//         vm.expectEmit(true, true, true, true);
//         emit eCreateProduct(expectProductID, params);

//         vm.prank(Controller);
//         productContract.createProduct(params);

//         verifyProduct(expectProductID, params);
//     }

//     function test_getProduct() public {
//         seedCategories(10);
//         seedProducts(20);

//         Product memory testProduct = productContract.getProduct(1);
//         assertEq(testProduct.id, 1);
//     }

//     function test_CreateProductRequireAdmin() public {
//         createProductParams memory params = generateCreateProductParams(false);
//         // vm.expectRevert(bytes("You are not allowed"));
//         vm.prank(Controller);
//         productContract.createProduct(params);
//     }

//     function test_CreateProductInvalidCategory() public {
//         vm.expectRevert(
//             bytes(
//                 '{"from": "EcomProduct.sol","code": 2, "message":"Category not found"}'
//             )
//         );
//         createProductParams memory params = generateCreateProductParams(true);
//         vm.prank(Controller);
//         productContract.createProduct(params);
//     }

//     function test_updateProduct() public{

//         seedCategories(10);
//         seedProducts(20);
//         createProductParams memory params;

//         bytes[] memory size = new bytes[](4);
//         size[0] = "S";
//         size[1] = "M";
//         size[2] = "L";
//         size[3] = "XL";

//         uint256[] memory capacity = new uint256[](3);
//         capacity[0] = 120;
//         capacity[1] = 130;
//         capacity[2] = 140;

//         params.name = "Product1";
//         params.categoryID = 1;
//         params.retailPrice = 335 * ONE_USDT;
//         params.vipPrice = 308 * ONE_USDT;
//         params.memberPrice = (2345 * ONE_USDT) / 10;
//         params.reward = (5901 * ONE_USDT) / 100;
//         params.capacity = capacity; // 150ml
//         params.size = size; // 150ml
//         params.quantity = 100;
//         params.color = new bytes[](0);
//         params.retailer = Retailer1; // Retailer's address
//         params.brandName = "Test Brand BeEarning";
//         params.shippingFee = 5;
//         params.warranty = "this is a warranty";

//         bytes[] memory testProductUrls = new bytes[](2);
//         testProductUrls[0] = "http://example.com/image1.png";
//         testProductUrls[1] = "http://example.com/image2.png";
//         params.images = testProductUrls;
//         params.videoUrl = "http://example.com/video.mp4";
//         params.expiryTime = block.timestamp + 365 days; // Expiry after 1 year
//         params.activateTime = block.timestamp + 1 days;
//         params.isMultipleDiscount = false;

//         vm.prank(Controller);
//         bool success = productContract.updateProduct(1, params);
//         assertTrue(success);
//         Product memory product = productContract.getProduct(1);
//         assertEq(product.params.brandName, params.brandName);
//         assertEq(product.params.videoUrl, params.videoUrl);

//     }

//     function test_deleteProduct() public{

//         seedCategories(10);
//         seedProducts(20);

//         vm.prank(Controller);
//         productContract.deleteProduct(1);

//         vm.prank(Retailer1);
//         Product[] memory products1 = productContract.getRetailerProduct(Retailer1);
//         vm.prank(Retailer2);
//         Product[] memory products2 = productContract.getRetailerProduct(Retailer2);
        
//         assertNotEq(products1.length,10, "This should be wrong");
//         assertEq(products2.length, 10, "This should be correct");

//     }

//     function test_deleteAllProduct() public{
//         seedCategories(10);
//         seedProducts(20);
        
//         for (uint i = 1; i <= 20; i++){
//           vm.prank(Controller);
//           productContract.deleteProduct(i);
//         }
//         vm.prank(Retailer1);
//         Product[] memory products1 = productContract.getRetailerProduct(Retailer1);
//         vm.prank(Retailer2);
//         Product[] memory products2 = productContract.getRetailerProduct(Retailer2);

//         Product[] memory allProducts = productContract.getProducts();
//         Product[] memory categoryProducts = productContract.getProductsByCategoryID(1);

//         assertEq(products1.length,0);
//         assertEq(products2.length,0);
//         assertEq(allProducts.length, 0);
//         assertEq(categoryProducts.length,0);
//     }

//     function test_updateCategory() public{

//         seedCategories(10);
//         seedProducts(20);
       
//         Category memory category1 = productContract.getCategory(1);
//         string memory updatedName = "hehehehe";
//         string memory updatedDescription = "hahahaha";

//         assertNotEq(category1.name, updatedName);
//         assertNotEq(category1.description, updatedDescription);
        
//         vm.prank(Sender);
//         productContract.editCategory(1, updatedName, updatedDescription );
        
//         Category memory category = productContract.getCategory(1);

//         assertEq(category.name, updatedName);
//         assertEq(category.description, updatedDescription);
//     }


//     function test_deleteCategory() public{
//         uint256 totalCategories = 10;
//         seedCategories(totalCategories);

//         for (uint i = 1; i <= totalCategories; i++){
//           vm.prank(Sender);
//           productContract.deleteCategory(i); 
//         }
        
//         Category[] memory categories = productContract.getCategories();
//         assertEq(categories.length,0);
//     }

//     function test_CreateCart() public {
//         // TODO: test_CreateCart
//     }

//     function test_CreateMultipleCartItemsInCart() public {
//         seedCategories(10);
//         seedProducts(20);

//         address user = address(0);
//         ProductContract.AddItemToCartParams[]
//             memory items = new ProductContract.AddItemToCartParams[](3);
//         items[0] = ProductContract.AddItemToCartParams(1, 2);
//         items[1] = ProductContract.AddItemToCartParams(3, 4);
//         items[2] = ProductContract.AddItemToCartParams(5, 6);

//         vm.prank(user);
//         CartItem[] memory itemsInCart = productContract.addItemsToCart(
//             items
//         );

//         vm.prank(user);
//         Cart memory newCart1 = productContract.getUserCart();
//         assertEq(newCart1.items.length, itemsInCart.length);
//         assertEq(itemsInCart.length, 3);
//     }

//     function test_updateMultipleItemsInCart() public {
//         seedCategories(10);
//         seedProducts(20);

//         address user = address(0);
//         ProductContract.AddItemToCartParams[]
//             memory items = new ProductContract.AddItemToCartParams[](3);
//         items[0] = ProductContract.AddItemToCartParams(1, 2);
//         items[1] = ProductContract.AddItemToCartParams(3, 4);
//         items[2] = ProductContract.AddItemToCartParams(5, 6);

//         vm.startPrank(user);
//         CartItem[] memory itemsInCart = productContract.addItemsToCart(
//             items
//         );

//         Cart memory newCart1 = productContract.getUserCart();
//         assertEq(newCart1.items.length, itemsInCart.length);
//         assertEq(itemsInCart.length, 3);

//         ProductContract.UpdateItemsToCartParams[]
//             memory items1 = new ProductContract.UpdateItemsToCartParams[](3);
//         items1[0] = ProductContract.UpdateItemsToCartParams(1, 5);
//         items1[1] = ProductContract.UpdateItemsToCartParams(2, 7);
//         items1[2] = ProductContract.UpdateItemsToCartParams(3, 9);

//         CartItem[] memory itemsInCart2 = productContract.updateItemsToCart(
//             items1
//         );

//         Cart memory newCart2 = productContract.getUserCart();
//         assertEq(newCart2.items.length, itemsInCart2.length);
//         assertEq(newCart2.items[1].quantity, 7);
//         vm.stopPrank();
//     }

//     function verifyProductsAndCategoryName(
//         Product[] memory products,
//         string memory categoryName
//     ) public view {
//         for (uint256 i = 0; i < products.length; i++) {
//             Category memory category = productContract.getCategory(
//                 products[i].params.categoryID
//             );
//             assertEq(category.name, categoryName);
//         }
//     }

//     function verifyProductsAndBrandName(
//         Product[] memory products,
//         string memory brandName
//     ) public pure {
//         for (uint256 i = 0; i < products.length; i++) {
//             assertEq(products[i].params.brandName, brandName);
//         }
//     }

//     function verifyProductsAndPrice(
//         Product[] memory products,
//         PairPrices memory price
//     ) public pure {
//         for (uint256 i = 0; i < products.length; i++) {
//             if (price.fromPrice > 0) {
//                 assertLt(price.fromPrice, products[i].params.retailPrice);
//             }

//             if (price.toPrice > 0) {
//                 assertLt(products[i].params.retailPrice, price.toPrice);
//             }
//         }
//     }

//     function verifyProduct(
//         uint256 productId,
//         createProductParams memory params
//     ) public view {
//         Product memory product = productContract.getProduct(productId);

//         // Verify the product details
//         assertEq(product.id, productId);

//         assertEq(product.params.name, params.name);
//         assertEq(product.params.categoryID, params.categoryID);
//         assertEq(product.params.retailPrice, params.retailPrice);
//         assertEq(product.params.vipPrice, params.vipPrice);
//         assertEq(product.params.memberPrice, params.memberPrice);
//         assertEq(product.params.reward, params.reward);
//         assertEq(product.params.capacity, params.capacity);
//         assertEq(product.params.quantity, params.quantity);
//         assertEq(product.params.color, params.color);
//         assertEq(product.params.retailer, params.retailer);
//         assertEq(product.params.brandName, params.brandName);
//         assertEq(product.params.images, params.images);
//         assertEq(product.params.videoUrl, params.videoUrl);
//         assertEq(product.params.expiryTime, params.expiryTime);
//         assertEq(product.params.activateTime, params.activateTime);
//         assertEq(product.params.isMultipleDiscount, params.isMultipleDiscount);
//     }

//     function test_CreateShippingInfo() public {
//         ShippingParams memory shippingParams = generateShippingParams();
//         uint256 orderID = 1;
//         address user = address(0);

//         vm.expectEmit(true, true, true, true);
//         emit eCreateShipping(
//             1,
//             1,
//             user,
//             shippingParams.firstName,
//             shippingParams.lastName,
//             shippingParams.email,
//             shippingParams.country,
//             shippingParams.city,
//             shippingParams.stateOrProvince,
//             shippingParams.postalCode,
//             shippingParams.phone,
//             shippingParams.addressDetail
//         );

//         productContract.createShippingInfo(shippingParams, orderID, user);
//     }

//     // function test_TemporaryCreateOrder() public {
//     //     seedCategories(10);
//     //     seedProducts(20);

//     //     address user = address(0);
//     //     vm.prank(user);
//     //     productContract.addItemToCart(1, 2);

//     //     CreateOrderParams[] memory params = generateCreateOrderParams();

//     //     ShippingParams memory shippingParams = generateShippingParams();

//     //     uint256 price1 = productContract.getProduct(1).params.vipPrice * 2;
//     //     uint256 price2 = productContract.getProduct(2).params.vipPrice * 3;
//     //     uint256 price3 = productContract.getProduct(3).params.vipPrice * 4;

//     //     uint256 totalPriceWithoutDiscount = price1 + price2 + price3;

//     //     bytes32 codeRef;
//     //     address[] memory relatedAddress;

//     //     // Expect create shipping info
//     //     uint256 expectOrderIdCounter = 1;
//     //     // vm.expectEmit(true, true, true, true);
//     //     emit eCreateOrder(expectOrderIdCounter);

//     //     // vm.expectEmit(true, true, true, true);
//     //     // emit ESpendUsdt(
//     //     //     address(productContract),
//     //     //     totalPriceWithoutDiscount,
//     //     //     address(productContract),
//     //     //     abi.encodeCall(
//     //     //         productContract.temporaryExecuteOrder,
//     //     //         expectOrderIdCounter
//     //     //     ),
//     //     //     relatedAddress
//     //     // );

//     //     ProductContract.orderDetails memory details = ProductContract.orderDetails(totalPriceWithoutDiscount, "refCode",CheckoutType.RECEIVE,PaymentType.VISA);

//     //     productContract.temporaryCreateOrder(
//     //         params,
//     //         shippingParams,
//     //         user,
//     //         details
//     //     );
//     // }

//     function test_TemporaryCreateOrderWithEmptyParams() public {
//         seedCategories(10);
//         seedProducts(20);
//         vm.expectRevert(
//             bytes(
//                 '{"from": "EcomProduct.sol","code": 11, "message":"Order have no item"}'
//             )
//         );

//         CreateOrderParams[] memory params;
//         ShippingParams memory shippingParams;
//         uint256 totalPriceWithoutDiscount = 0;
//         bytes32 codeRef;
//         address[] memory relatedAddress;
//         ProductContract.orderDetails memory details = ProductContract.orderDetails(totalPriceWithoutDiscount, codeRef,CheckoutType.RECEIVE,PaymentType.VISA);

//         productContract.ExecuteOrderUSDT(
//             params,
//             shippingParams,
//             address(0),
//             details
//         );
//     }

//     function test_TemporaryCreateOrderWithProductNotFound() public {
//         seedCategories(10);
//         seedProducts(20);
//         vm.expectRevert(
//             bytes(
//                 '{"from": "EcomProduct.sol","code": 13, "message": "cartItemId does not exist in the cart"}'
//             )
//         );

//         CreateOrderParams[] memory params = generateCreateOrderParams();
//         params[0].productID = 999; // Product ID Not Found

//         ShippingParams memory shippingParams;
//         uint256 totalPriceWithoutDiscount = 0;
//         bytes32 codeRef;
//         address[] memory relatedAddress;
//         ProductContract.orderDetails memory details = ProductContract.orderDetails(totalPriceWithoutDiscount, codeRef,CheckoutType.RECEIVE,PaymentType.VISA);

//         productContract.ExecuteOrderUSDT(
//             params,
//             shippingParams,
//             address(0),
//             details
//         );
//     }

//     function test_getTotalProductViewCount() public {
//         seedCategories(10);
//         seedProducts(20);

//         for (uint i = 0; i < 5; i++) {
//             productContract.updateViewCount(1);
//         }

//         for (uint i = 0; i < 10; i++) {
//             productContract.updateViewCount(7);
//         }

//         for (uint i = 0; i < 20; i++) {
//             productContract.updateViewCount(6);
//         }

//         vm.prank(Sender);
//         (
//             uint256[] memory productIds,
//             uint256[] memory productCount
//         ) = productContract.getTotalProductViewCount();

//         assertEq(
//             productIds.length,
//             20,
//             "Product IDs array should have length 20"
//         );
//         assertEq(
//             productCount.length,
//             20,
//             "Product counts array should have length 20"
//         );

//         // Check the specific product view counts
//         assertEq(productCount[0], 5, "Product with ID 1 should have 5 views");
//         assertNotEq(
//             productCount[5],
//             19,
//             "Product with ID 1 should have 20 views"
//         );
//         assertEq(productCount[6], 10, "Product with ID 1 should have 10 views");

//         // assertEq(productCount[7], 10, "
//     }

//     function test_getProductTrend() public {
//         seedCategories(10);
//         seedProducts(20);
//         vm.warp(31536001);
//         for (uint i = 0; i < 5; i++) {
//             productContract.updateViewCount(1);
//         }

//         for (uint i = 0; i < 10; i++) {
//             productContract.updateViewCount(7);
//         }

//         for (uint i = 0; i < 20; i++) {
//             productContract.updateViewCount(6);
//         }

//         // Test for product ID 7
//         uint256[] memory times7 = productContract.getProductTrend(7);
//         assertEq(
//             times7.length,
//             10,
//             "Product ID 7 should have 10 search trends"
//         );

//         // Test for product ID 6
//         uint256[] memory times6 = productContract.getProductTrend(6);

//         assertEq(
//             times6.length,
//             20,
//             "Product ID 6 should have 20 search trends"
//         );
//     }

//     function seedData() internal {
//         seedCategories(10);
//         seedProducts(10);
//     }

//     function addItemToCart(
//         uint256 productId,
//         uint256 quantity
//     ) internal {
//         productContract.addItemToCart(productId, quantity);
//     }

//     function createOrder(
//         address user,
//         uint256 totalPriceWithoutDiscount,
//         bytes32 codeRef,
//         CreateOrderParams[] memory params,
//         ShippingParams memory shippingParams,
//         CheckoutType checkoutType
//     ) internal returns (uint256) {
//         ProductContract.orderDetails memory details = ProductContract.orderDetails(
//           totalPriceWithoutDiscount,
//           codeRef,
//           checkoutType,
//           PaymentType.VISA
//         );
//         return productContract.ExecuteOrderUSDT(
//                 params,
//                 shippingParams,
//                 user,
//                 details
//         );
//     }
//     function EncodeParamsExecuteOrder(
//         CreateOrderParams[] memory params,
//         ShippingParams memory shippingParams,
//         address user,
//         ProductContract.orderDetails memory details
//     ) public returns (bytes memory) {
//         uint256 _data = productContract.CreateParamsForExecuteOrder(params, shippingParams, user, details);
//         return abi.encode(_data);
//     }

//     function createOrderLock(
//         address user,
//         uint256 totalPriceWithoutDiscount,
//         bytes32 codeRef,
//         CreateOrderParams[] memory params,
//         ShippingParams memory shippingParams,
//         CheckoutType checkoutType,
//         uint256 totalPrice,
//         bytes32 paymentID
//     ) internal returns (bool) {
//         ProductContract.orderDetails memory details = ProductContract.orderDetails(
//           totalPriceWithoutDiscount,
//           codeRef,
//           checkoutType,
//           PaymentType.VISA
//         );

//         bytes memory encode = EncodeParamsExecuteOrder(params, shippingParams, user, details);
        
//         return productContract.ExecuteOrder(
//             encode,
//             paymentID,
//             totalPrice
//         );
//     }

//     function createOrderStorage(
//         address user,
//         uint256 totalPriceWithoutDiscount,
//         bytes32 codeRef,
//         CreateOrderParams[] memory params,
//         ShippingParams memory shippingParams
//     ) internal returns (uint256) {
//         ProductContract.orderDetails memory details = ProductContract.orderDetails(totalPriceWithoutDiscount, codeRef,CheckoutType.STORAGE,PaymentType.VISA);
//         return
//             productContract.ExecuteOrderUSDT(
//                 params,
//                 shippingParams,
//                 user,
//                 details
//             );
//     }

//     // function executeOrder(uint256 orderId, uint256 totalPrice) internal {
//     //     vm.prank(Sender);
//     //     USDT_ERC.mintToAddress(address(0x19), totalPrice);
//     //     vm.prank(address(0x19));
//     //     USDT_ERC.approve(address(productContract), totalPrice);
//     //     vm.prank(address(0x19));
//     //     bool success = productContract.temporaryExecuteOrder(orderId);
//     //     assertTrue(success);
//     // }

//     function warpTime(uint256 time) internal {
//         vm.warp(time);
//     }

//     // function test_TemporaryExecuteOrder() public {
//     //   seedData();
//     //
//     //   address user1 = address(1);
//     //
//     //   addItemToCart(user1, 2, 1);
//     //
//     //   warpTime(31536001);
//     //     Cart memory newCart1 = productContract.getUserCart(user1);
//     //     assertEq(newCart1.id, 1);
//     //
//     //     CreateOrderParams[] memory params1 = generateCreateOrderParams0();
//     //     ShippingParams memory shippingParams = generateShippingParams();
//     //     uint256 totalPrice1 = productContract.getProduct(1).params.vipPrice +
//     //         productContract.getProduct(2).params.vipPrice;
//     //     uint256 orderID1 = createOrder(
//     //         user1,
//     //         totalPrice1,
//     //         "refCode1234",
//     //         params1,
//     //         shippingParams
//     //     );
//     //     assertEq(orderID1, 1);
//     //
//     //     Order memory order1 = productContract.getOrder(orderID1);
//     //     executeOrder(orderID1, order1.totalPrice);
//     //
//     //     address user2 = address(2);
//     //     addItemToCart(user2, 3, 1);
//     //     addItemToCart(user2, 4, 1);
//     //
//     //     warpTime(31536001);
//     //     Cart memory newCart2 = productContract.getUserCart(user2);
//     //     assertEq(newCart2.id, 2);
//     //
//     //     CreateOrderParams[] memory params2 = generateCreateOrderParams1();
//     //     uint256 totalPrice2 = productContract.getProduct(1).params.vipPrice +
//     //         productContract.getProduct(2).params.vipPrice;
//     //     uint256 orderID2 = createOrder(
//     //         user2,
//     //         totalPrice2,
//     //         "refCode1234",
//     //         params2,
//     //         shippingParams
//     //     );
//     //     assertEq(orderID2, 2);
//     //
//     //     Order memory order2 = productContract.getOrder(orderID2);
//     //     executeOrder(orderID2, order2.totalPrice);
//     //
//     //     vm.prank(user2);
//     //     Purchase[] memory purchases = productContract.getRecentPurchases();
//     //     BestSeller[] memory bestSellers = productContract.getBestSeller();
//     //     assertTrue(purchases.length > 1);
//     //     assertTrue(bestSellers.length > 1);
//     // }
//     //

//     function test_getManyUserInfo() public {
//         uint256 totalUser = 5;
//         createManyUsers(totalUser);
//         vm.prank(Controller);
//         ProductContract.UserInfo[] memory users = productContract
//             .getUsersInfo();
//         assertTrue(users.length == totalUser + EXISTS_USER);
//     }

//     function test_updateManyUserInfo() public {
//         uint256 totalUser = 5;
//         createManyUsers(totalUser);

//         // Initial verification
//         vm.prank(Controller);
//         ProductContract.UserInfo[] memory users = productContract
//             .getUsersInfo();
//         assertTrue(users.length == totalUser + EXISTS_USER);
//         ProductContract.AddressInfo[]
//             memory addressInfo = new ProductContract.AddressInfo[](1);
//         addressInfo[0] = ProductContract.AddressInfo({
//             country: "Country",
//             city: "City",
//             state: "State",
//             postalCode: "12345",
//             detailAddress: "Address"
//         });

//         ProductContract.registerParams memory params = ProductContract
//             .registerParams({
//                 fullName: "update name",
//                 email: "updatemail@gmail.com",
//                 gender: 1,
//                 dateOfBirth: block.timestamp,
//                 phoneNumber: "0909090909"
//             });

//         // Update user information
//         for (uint i = 0; i < totalUser; i++) {
//             vm.prank(convertUint256ToAddress(i));
//             // Assuming there's a function updateUser that accepts some parameters to update user info
//             bool success = productContract.updateUserInfo(params, addressInfo);
//             assertTrue(success);
//         }

//         // Fetch updated user information
//         vm.prank(Controller);
//         ProductContract.UserInfo[] memory updatedUsers = productContract
//             .getUsersInfo();

//         // Verify the updates
//         for (uint i = EXISTS_USER; i < updatedUsers.length; i++) {
//             assertEq(updatedUsers[i].fullName, params.fullName);
//         }
//     }

//     function test_deleteManyUser() public {
//         uint256 totalUser = 5;
//         createManyUsers(totalUser);
//         vm.prank(Controller);
//         ProductContract.UserInfo[] memory users = productContract
//             .getUsersInfo();
//         assertTrue(users.length == totalUser + EXISTS_USER);

//         for (uint i = 0; i < totalUser; i++) {
//             vm.prank(convertUint256ToAddress(i));
//             bool success = productContract.deleteUser();
//             assertTrue(success);
//         }
//         vm.prank(Controller);
//         ProductContract.UserInfo[] memory users1 = productContract
//             .getUsersInfo();
//         assertTrue(users1.length == EXISTS_USER);
//     }

//     function createManyUsers(uint256 _total) internal {
//         for (uint i = 0; i < _total; i++) {
//             vm.prank(convertUint256ToAddress(i));
//             createUser();
//         }
//     }

//     function generateCreateStorageOrderParams()
//         internal
//         view
//         returns (CreateOrderStorageParams[] memory)
//     {
//         CreateOrderStorageParams memory params1 = CreateOrderStorageParams(
//             1,
//             1,
//             190 * ONE_USDT
//         );

//         CreateOrderStorageParams memory params2 = CreateOrderStorageParams(
//             2,
//             1,
//             309 * ONE_USDT
//         );

//         CreateOrderStorageParams[]
//             memory params = new CreateOrderStorageParams[](2);
//         params[0] = params1;
//         params[1] = params2;

//         return params;
//     }

//     // function createOrderForStorage(
//     //     address user,
//     //     uint256 totalPriceWithoutDiscount,
//     //     bytes32 codeRef,
//     //     CreateOrderParams[] memory params,
//     //     ShippingParams memory shippingParams
//     // ) internal returns (uint256) {
//     //     return productContract.(
//     //         params,
//     //         shippingParams,
//     //         user,
//     //         totalPriceWithoutDiscount,
//     //         codeRef,
//     //         CheckoutType.STORAGE,
//     //         PaymentType.VISA
//     //     );
//     // }

//     // function test_TemporaryStorageExecuteOrder() public {
//     //     seedCategories(10);
//     //     seedProducts(20);
//     //     address user = address(1);
//     //     productContract.addItemToCart(user, 1, 2);
//     //     vm.warp(31536001);
//     //     Cart memory newCart1 = productContract.getUserCart(user);
//     //     assertEq(newCart1.id, 1);
//     //     CreateOrderParams[] memory params = generateCreateOrderParams();
//     //     ShippingParams memory shippingParams = generateShippingParams();

//     //     uint256 price1 = productContract.getProduct(1).params.vipPrice * 2;
//     //     uint256 price2 = productContract.getProduct(2).params.vipPrice * 3;
//     //     uint256 price3 = productContract.getProduct(3).params.vipPrice * 4;

//     //     uint256 totalPriceWithoutDiscount = price1 + price2 + price3;
//     //     bytes32 codeRef;
//     //     address[] memory relatedAddress;
//     //     uint256 orderID = productContract.temporaryCreateOrder(
//     //         params,
//     //         shippingParams,
//     //         user,
//     //         totalPriceWithoutDiscount,
//     //         codeRef,
//     //         CheckoutType.RECEIVE,
//     //         PaymentType.VISA
//     //     );

//     //     assertEq(orderID, 1);

//     //     bool test = productContract.temporaryExecuteOrder(1);
//     //     assertTrue(test);

//     //     CreateOrderStorageParams[]
//     //         memory params2 = generateStorageOrderParams();
//     //     (uint256 _parentOrderID, uint256 _orderID) = productContract
//     //         .createOrderByStorageOrder(
//     //             params2,
//     //             1,
//     //             shippingParams,
//     //             address(2),
//     //             totalPriceWithoutDiscount,
//     //             codeRef,
//     //             relatedAddress
//     //         );

//     //     // assertEq(_parentOrderID, _orderID);

//     //     bool something = productContract.executeOrderByStorageOrder(
//     //         _parentOrderID,
//     //         _orderID
//     //     );

//     //     vm.prank(address(2));

//     //     assertTrue(something);
//     // }

//     function generateStorageOrderParams()
//         internal
//         pure
//         returns (CreateOrderStorageParams[] memory)
//     {
//         CreateOrderStorageParams memory params1 = CreateOrderStorageParams(
//             1,
//             2,
//             5000
//         );

//         CreateOrderStorageParams[]
//             memory params = new CreateOrderStorageParams[](1);
//         params[0] = params1;

//         return params;
//     }

//     function test_createListTrackUser() public {
//         seedCategories(10);
//         seedProducts(20);

//         uint256[] memory params1 = new uint256[](3);
//         uint256[] memory params2 = new uint256[](3);
//         uint256[] memory params3 = new uint256[](3);

//         params1[0] = 1;
//         params1[1] = 2;
//         params1[2] = 3;

//         params2[0] = 4;
//         params2[1] = 5;
//         params2[2] = 6;

//         params3[0] = 7;
//         params3[1] = 8;
//         params3[2] = 9;

//         productContract.createListTrackUser(
//             createListTrackUserParams("order5", 1, address(0), params1, params1)
//         );
//         productContract.createListTrackUser(
//             createListTrackUserParams("order2", 1, address(1), params2, params2)
//         );
//         productContract.createListTrackUser(
//             createListTrackUserParams("order3", 1, address(2), params3, params3)
//         );

//         // Verify the listTrackUserSystem entries
//         vm.prank(Sender);
//         ListTrackUser[] memory systemList = productContract.getListTrackUser();

//         assertEq(systemList.length, 3);
//         assertEq(systemList[0].orderID, "order5");
//         assertEq(systemList[1].orderID, "order2");
//         assertEq(systemList[2].orderID, "order3");

//         // Verify that the retailers match the products
//         for (uint i = 0; i < params1.length; i++) {
//             Product memory product = productContract.getProduct(params1[i]);
//             vm.prank(product.params.retailer);
//             ListTrackUser[] memory retailerList = productContract
//                 .getListTrackUserRetailer();
//             assertEq(retailerList[0].orderID, "order5");
//         }

//         for (uint i = 0; i < params2.length; i++) {
//             Product memory product = productContract.getProduct(params2[i]);
//             vm.prank(product.params.retailer);
//             ListTrackUser[] memory retailerList = productContract
//                 .getListTrackUserRetailer();
//             assertEq(retailerList[0].orderID, "order5");
//         }

//         for (uint i = 0; i < params3.length; i++) {
//             Product memory product = productContract.getProduct(params3[i]);
//             vm.prank(product.params.retailer);
//             ListTrackUser[] memory retailerList = productContract
//                 .getListTrackUserRetailer();

//             assertEq(retailerList[0].orderID, "order5");
//         }
//     }

//     function test_deleteListTrackUser() public {
//         seedCategories(10);
//         seedProducts(20);

//         uint256[] memory params1 = new uint256[](3);
//         uint256[] memory params2 = new uint256[](3);
//         uint256[] memory params3 = new uint256[](3);

//         params1[0] = 1;
//         params1[1] = 2;
//         params1[2] = 3;

//         params2[0] = 4;
//         params2[1] = 5;
//         params2[2] = 6;

//         params3[0] = 7;
//         params3[1] = 8;
//         params3[2] = 9;

//         productContract.createListTrackUser(
//             createListTrackUserParams("order5", 1, address(0), params1, params1)
//         );
//         productContract.createListTrackUser(
//             createListTrackUserParams("order2", 1, address(1), params2, params2)
//         );
//         productContract.createListTrackUser(
//             createListTrackUserParams("order3", 1, address(2), params3, params3)
//         );

//         // Verify the listTrackUserSystem entries
//         productContract.deleteListTrackUser("order5");

//         vm.prank(Sender);
//         ListTrackUser[] memory systemList2 = productContract.getListTrackUser();

//         for (uint i = 0; i < systemList2.length; i++) {
//             assertNotEq(systemList2[i].orderID, "order5");
//         }

//         for (uint i = 0; i < systemList2.length; i++) {
//             assertNotEq(systemList2[i].orderID, "order5");
//         }
//     }

//     function test_RemoveTrackUserActivitySystem() public {
//         seedCategories(10);
//         seedProducts(20);

//         vm.warp(currentTime);

//         vm.startPrank(address(0x999999));
//         productContract.createFavorite(1);
//         productContract.createFavorite(2);
//         productContract.createFavorite(3);
//         productContract.createFavorite(4);
//         productContract.createFavorite(5);
//         vm.stopPrank();

//         vm.prank(address(0x59595));
//         productContract.addItemToCart(1, 5);

//         vm.startPrank(address(0x123123));
//         productContract.addItemToCart(2, 7);
//         productContract.addItemToCart(3, 8);
//         productContract.addItemToCart(4, 9);
//         productContract.addItemToCart(5, 1);
//         productContract.addItemToCart(7, 1);
//         vm.stopPrank();


//         vm.prank(Sender);
//         AddedToCartAndWishList[] memory test = productContract
//             .getListTrackUserActivitySystem();

//         vm.prank(Retailer2);
//         AddedToCartAndWishList[] memory test1 = productContract
//             .getListTrackUserActivityRetailer();

//         vm.prank(Retailer1);
//         AddedToCartAndWishList[] memory test2 = productContract
//             .getListTrackUserActivityRetailer();

//         // 3 Customer had added favorite + to cart
//         assertEq(test.length, 3);
//         // Retailer2 have 2 customer: 
//         // 0x9999 in wishlist product's 2,4
//         // 0x123123 in cart product's 2,4
//         assertEq(test1.length, 2);
//         // Retailer 1 will have even product
//         assertEq(test2.length, 3);

//         vm.startPrank(address(0x999999));
//         productContract.deleteFavorite(1);
//         productContract.deleteFavorite(2);
//         productContract.deleteFavorite(3);
//         productContract.deleteFavorite(4);
//         productContract.deleteFavorite(5);
//         vm.stopPrank();

//         vm.prank(address(0x59595));
//         productContract.deleteItemInCart(1);

//         vm.startPrank(address(0x123123));
//         productContract.deleteItemInCart(2);
//         productContract.deleteItemInCart(3);
//         productContract.deleteItemInCart(4);
//         productContract.deleteItemInCart(5);
//         productContract.deleteItemInCart(6);
//         vm.stopPrank();

//         vm.prank(Sender);
//         AddedToCartAndWishList[] memory listTrack = productContract
//             .getListTrackUserActivitySystem();

//         vm.prank(Retailer2);
//         AddedToCartAndWishList[] memory listTrack1 = productContract
//             .getListTrackUserActivityRetailer();

//         vm.prank(Retailer1);
//         AddedToCartAndWishList[] memory listTrack2 = productContract
//             .getListTrackUserActivityRetailer();

//         assertEq(listTrack.length, 0);
//         assertEq(listTrack1.length, 0);
//         assertEq(listTrack2.length, 0);
//     }


//     function test_createUser() public {
//         vm.prank(address(1));
//         ProductContract.registerParams memory params = ProductContract
//             .registerParams({
//                 fullName: "hehe",
//                 email: "hehe@gmail.com",
//                 gender: 1,
//                 dateOfBirth: block.timestamp,
//                 phoneNumber: "0909090909"
//             });

//         createUser();

//         vm.prank(address(1));
//         (ProductContract.UserInfo memory user, ) = productContract
//             .getUserInfo();
//         assertEq(user.fullName, params.fullName);
//     }

//     function test_editUser() public {
//         vm.startPrank(address(1));
//         createUser();

//         ProductContract.AddressInfo[]
//             memory tempAddressInfo = new ProductContract.AddressInfo[](0);
//         (ProductContract.UserInfo memory user, ) = productContract
//             .getUserInfo();
//         assertEq(user.fullName, "hehe");
//         ProductContract.registerParams memory params = ProductContract
//             .registerParams({
//                 fullName: "update name",
//                 email: "updatemail@gmail.com",
//                 gender: 1,
//                 dateOfBirth: block.timestamp,
//                 phoneNumber: "0909090909"
//             });

//         bool success = productContract.updateUserInfo(params, tempAddressInfo);

//         (
//             ProductContract.UserInfo memory updatedUser,
//             ProductContract.AddressInfo[] memory updatedAddresses
//         ) = productContract.getUserInfo();
//         assertEq(updatedUser.fullName, params.fullName);
//         assertEq(updatedAddresses.length, tempAddressInfo.length);
//         assertTrue(success);
//         vm.stopPrank();
//     }

//     function test_editUserWithAddressInfo() public {
//         // Start the prank and create a user
//         vm.startPrank(address(1));
//         createUser();
//         // (
//         //     ProductContract.UserInfo memory user,
//         //     ProductContract.AddressInfo[] memory addressInfo1
//         // ) = productContract.getUserInfo();

//         // assertEq
//         // Define the updated user information
//         ProductContract.AddressInfo[]
//             memory addressInfo = new ProductContract.AddressInfo[](1);
//         addressInfo[0] = ProductContract.AddressInfo({
//             country: "Country",
//             city: "City",
//             state: "State",
//             postalCode: "12345",
//             detailAddress: "Address"
//         });

//         ProductContract.registerParams memory params = ProductContract
//             .registerParams({
//                 fullName: "update name",
//                 email: "updatemail@gmail.com",
//                 gender: 1,
//                 dateOfBirth: block.timestamp,
//                 phoneNumber: "0909090909"
//             });

//         // Update the user information
//         bool success = productContract.updateUserInfo(params, addressInfo);
//         assertTrue(success, "Failed to update user information");

//         // Retrieve the updated user information
//         (
//             ProductContract.UserInfo memory updatedUser,
//             ProductContract.AddressInfo[] memory updatedAddresses
//         ) = productContract.getUserInfo();
//         // // Perform assertions to verify the updated user information
//         assertEq(
//             updatedUser.fullName,
//             params.fullName,
//             "Full name not updated correctly"
//         );
//         assertEq(
//             updatedUser.email,
//             params.email,
//             "Email not updated correctly"
//         );
//         assertEq(
//             updatedUser.gender,
//             params.gender,
//             "Gender not updated correctly"
//         );
//         assertEq(
//             updatedUser.dateOfBirth,
//             params.dateOfBirth,
//             "Date of birth not updated correctly"
//         );
//         assertEq(
//             updatedUser.phoneNumber,
//             params.phoneNumber,
//             "Phone number not updated correctly"
//         );

//         // Perform assertions to verify the updated address information
//         assertEq(
//             addressInfo[0].country,
//             updatedAddresses[0].country,
//             "Country not updated correctly"
//         );
//         assertEq(
//             addressInfo[0].city,
//             addressInfo[0].city,
//             "City not updated correctly"
//         );
//         assertEq(
//             addressInfo[0].state,
//             addressInfo[0].state,
//             "State not updated correctly"
//         );
//         assertEq(
//             addressInfo[0].postalCode,
//             addressInfo[0].postalCode,
//             "Postal code not updated correctly"
//         );
//         assertEq(
//             addressInfo[0].detailAddress,
//             addressInfo[0].detailAddress,
//             "Detail address not updated correctly"
//         );

//         // Stop the prank
//         vm.stopPrank();
//     }

//     function createUser() internal {
//         ProductContract.registerParams memory params = ProductContract
//             .registerParams({
//                 fullName: "hehe",
//                 email: "hehe@gmail.com",
//                 gender: 1,
//                 dateOfBirth: block.timestamp,
//                 phoneNumber: "0909090909"
//             });

//         bool success = productContract.register(params);
//         assertTrue(success);
//     }

//     function test_createComment() public {
//         seedCategories(10);
//         seedProducts(20);
//         uint256 productID = 1;
//         string memory content = "Great product!";
//         string memory name = "Alice";

//         vm.prank(Controller);
//         productContract.createComment(
//             productID,
//             CommentType.REVIEW,
//             content,
//             name
//         );
//         Comment memory newComment = productContract.getComment(1);

//         assertEq(newComment.id, 1);
//         assertEq(newComment.user, Controller);
//         assertEq(newComment.name, name);
//         assertEq(newComment.message, content);
//     }

//     function test_createComments() public {
//         seedCategories(10);
//         seedProducts(20);
//         uint256 productID = 1;

//         // Define the parameters for multiple comments
//         ProductContract.createCommentParams[]
//             memory params = new ProductContract.createCommentParams[](2);
//         params[0] = ProductContract.createCommentParams({
//             commentType: CommentType.REVIEW,
//             content: "Great product!",
//             name: "Alice"
//         });
//         params[1] = ProductContract.createCommentParams({
//             commentType: CommentType.PRESSCOMMENT,
//             content: "Does it come in blue?",
//             name: "Bob"
//         });

//         // Call the function to create multiple comments
//         vm.prank(Controller);
//         productContract.createComments(productID, params);

//         // Retrieve and check the first comment
//         Comment memory comment1 = productContract.getComment(1);
//         assertEq(comment1.id, 1);
//         assertEq(comment1.name, "Alice");
//         assertEq(comment1.message, "Great product!");
//         assertEq(comment1.commentType, uint8(CommentType.REVIEW));
//         assertEq(comment1.productID, productID);

//         // Retrieve and check the second comment
//         Comment memory comment2 = productContract.getComment(2);
//         assertEq(comment2.id, 2);
//         assertEq(comment2.name, "Bob");
//         assertEq(comment2.message, "Does it come in blue?");
//         assertEq(comment2.commentType, uint8(CommentType.PRESSCOMMENT));
//         assertEq(comment2.productID, productID);

//         // Ensure the comments are correctly associated with the product
//         Comment[] memory productComments = productContract.getAllComments(
//             productID
//         );
//         assertEq(productComments.length, 2);
//         assertEq(productComments[0].id, 1);
//         assertEq(productComments[1].id, 2);
//     }

//     function test_editComments() public {
//         seedCategories(10);
//         seedProducts(20);
//         uint256 productID = 1;

//         // First, create some initial comments to edit later
//         ProductContract.createCommentParams[]
//             memory createParams = new ProductContract.createCommentParams[](2);
//         createParams[0] = ProductContract.createCommentParams({
//             commentType: CommentType.REVIEW,
//             content: "Great product!",
//             name: "Alice"
//         });
//         createParams[1] = ProductContract.createCommentParams({
//             commentType: CommentType.PRESSCOMMENT,
//             content: "Does it come in blue?",
//             name: "Bob"
//         });

//         vm.prank(Controller);
//         productContract.createComments(productID, createParams);

//         // Define the parameters for editing the comments
//         ProductContract.editCommentsParam[]
//             memory editParams = new ProductContract.editCommentsParam[](2);
//         editParams[0] = ProductContract.editCommentsParam({
//             commentID: 1,
//             content: "Updated review: still great!"
//         });
//         editParams[1] = ProductContract.editCommentsParam({
//             commentID: 2,
//             content: "Updated question: does it come in red?"
//         });

//         // Call the function to edit multiple comments
//         vm.prank(Controller);
//         productContract.editComments(productID, editParams);

//         // Retrieve and check the first edited comment
//         Comment memory editedComment1 = productContract.getComment(1);
//         assertEq(editedComment1.id, 1);
//         assertEq(editedComment1.message, "Updated review: still great!");

//         // Retrieve and check the second edited comment
//         Comment memory editedComment2 = productContract.getComment(2);
//         assertEq(editedComment2.id, 2);
//         assertEq(
//             editedComment2.message,
//             "Updated question: does it come in red?"
//         );

//         // Ensure the comments are correctly associated with the product and updated
//         Comment[] memory productComments = productContract.getAllComments(
//             productID
//         );
//         assertEq(productComments.length, 2);
//         assertEq(productComments[0].id, 1);
//         assertEq(productComments[0].message, "Updated review: still great!");
//         assertEq(productComments[1].id, 2);
//         assertEq(
//             productComments[1].message,
//             "Updated question: does it come in red?"
//         );
//     }
//     function test_createFAQ() public {
//         uint256 faqID = 1;
//         string memory title = "Test FAQ Title";
//         string memory content = "Test FAQ Content";
        
//         // Call the createFAQPO5 function
//         vm.prank(Sender); // Simulate the call from the owner
//         bool success = productContract.createFAQPO5(title, content);
        
//         // Check the function return
//         assertTrue(success);
        
//         // Retrieve the FAQ
//         FAQ[] memory faqs = productContract.getPO5FAQ();
        
//         // Verify the FAQ was created
//         assertEq(faqs.length, 1);
//         assertEq(faqs[0].title, title);
//         assertEq(faqs[0].content, content);
//         assertEq(faqs[0].id, faqID);
//     }

//     function test_updateFAQ() public {
//         uint256 faqID = 1;
//         string memory title = "Updated FAQ Title";
//         string memory content = "Updated FAQ Content";
        
//         // Create the FAQ first
//         vm.prank(Sender);
//         productContract.createFAQPO5("Original Title", "Original Content");
        
//         // Update the FAQ
//         vm.prank(Sender);
//         productContract.editFAQPO5(faqID, title, content);
        
//         // Retrieve the FAQ
//         FAQ[] memory faqs = productContract.getPO5FAQ();
        
//         // Verify the FAQ was updated
//         assertEq(faqs.length, 1);
//         assertEq(faqs[0].title, title);
//         assertEq(faqs[0].content, content);
//         assertEq(faqs[0].id, faqID);
//     }

//     function test_deleteFAQ() public {
//         uint256 faqID = 1;
//         string memory title = "Test FAQ Title";
//         string memory content = "Test FAQ Content";
        
//         // Create the FAQ first
//         vm.prank(Sender);
//         productContract.createFAQPO5(title, content);
        
//         // Delete the FAQ
//         vm.prank(Sender);
//         productContract.deleteFAQPO5(faqID);
        
//         // Retrieve the FAQs
//         FAQ[] memory faqs = productContract.getPO5FAQ();
        
//         // Verify the FAQ was deleted
//         assertEq(faqs.length, 0);
//     }

//         function test_createRating() public {
//         seedCategories(10);
//         seedProducts(20);
//         uint256 productID = 1;
//         uint256 rateValue = 5;
//         address user1 = address(0x123123123);
//         // Rate the product
//         vm.prank(user1);
//         bool success = productContract.createRating(productID, rateValue);

//         // Check the function return
//         assertTrue(success);

//         // Retrieve the rating
//         Rating[] memory ratings = productContract.getProductRate(productID);

//         // Verify the rating was created
//         assertEq(ratings.length, 1);
//         assertEq(ratings[0].rateValue, rateValue);
//         assertEq(ratings[0].user, user1);
//     }

//     function test_editRating() public {
//         seedCategories(10);
//         seedProducts(20);
//         uint256 productID = 1;
//         uint256 rateValue = 5;
//         uint256 newRateValue = 3;
//         address user1 = address(0x123123123);
//         // Rate the product first
//         vm.prank(user1);
//         productContract.createRating(productID, rateValue);

//         // Update the rating
//         vm.prank(user1);
//         bool success = productContract.editRating(productID, 1, newRateValue);

//         // Check the function return
//         assertTrue(success);

//         // Retrieve the rating
//         Rating[] memory ratings = productContract.getProductRate(productID);

//         // Verify the rating was updated
//         assertEq(ratings.length, 1);
//         assertEq(ratings[0].rateValue, newRateValue);
//     }

//     function test_deleteRating() public {
//         seedCategories(10);
//         seedProducts(20);
//         uint256 productID = 1;
//         uint256 rateValue = 5;
//         address user1 = address(0x123123123);
//         // Rate the product first
//         vm.prank(user1);
//         productContract.createRating(productID, rateValue);

//         // Retrieve the initial rating ID
//         Rating[] memory ratingsBefore = productContract.getProductRate(productID);
//         uint256 ratingID = ratingsBefore[0].id;

//         // Delete the rating
//         vm.prank(user1);
//         bool success = productContract.deleteRating(productID, ratingID);

//         // Check the function return
//         assertTrue(success);

//         // Verify the rating was deleted
//         Rating[] memory ratingsAfter = productContract.getProductRate(productID);
//         assertEq(ratingsAfter.length, 0);
//     }

//     function test_TrackUserActivityRetailer() public {
//         seedCategories(10);
//         seedProducts(20);
//     }

//     function generateCreateOrderParams()
//         public
//         pure
//         returns (CreateOrderParams[] memory)
//     {
//         string[] memory discountCodes;
//         CreateOrderParams memory params1 = CreateOrderParams(
//             1,
//             2,
//             1,
//             discountCodes
//         );
//         CreateOrderParams memory params2 = CreateOrderParams(
//             2,
//             2,
//             2,
//             discountCodes
//         );
//         CreateOrderParams memory params3 = CreateOrderParams(
//             3,
//             2,
//             3,
//             discountCodes
//         );

//         CreateOrderParams[] memory params = new CreateOrderParams[](3);
//         params[0] = params1;
//         params[1] = params2;
//         params[2] = params3;
//         return params;
//     }

//     function generateCreateOrderParams0()
//         public
//         pure
//         returns (CreateOrderParams[] memory)
//     {
//         string[] memory discountCodes;
//         CreateOrderParams memory params1 = CreateOrderParams(
//             1,
//             1,
//             1,
//             discountCodes
//         );
//         CreateOrderParams memory params2 = CreateOrderParams(
//             2,
//             1,
//             2,
//             discountCodes
//         );
//         CreateOrderParams[] memory params = new CreateOrderParams[](2);
//         params[0] = params1;
//         params[1] = params2;
//         return params;
//     }

//     // first testcase
//     // function test_executeOrder1() public {
//     //     seedCategories(10);
//     //     create3CorrectProduct();

//     //     uint256 quantity1 = 3;
//     //     uint256 quantity2 = 4;
//     //     address user1 = address(1);
//     //     vm.startPrank(user1);
//     //     addItemToCart(1, quantity1);
//     //     addItemToCart(2, quantity2);

//     //     warpTime(TIME);
//     //     Cart memory newCart1 = productContract.getUserCart();
//     //     assertEq(newCart1.id, 1);

//     //     vm.stopPrank();
//     //     CreateOrderParams[] memory params = _tempGenerateCreateOrderParams();

//     //     ShippingParams memory shippingParams = generateShippingParams();
//     //     uint256 totalPrice = productContract.getProduct(1).params.vipPrice *
//     //         quantity1 +
//     //         productContract.getProduct(2).params.vipPrice *
//     //         quantity2;

//     //     uint256 orderID = createOrder(
//     //         user1,
//     //         0,
//     //         "refCode1234",
//     //         params,
//     //         shippingParams,
//     //         CheckoutType.RECEIVE
//     //     );

//     //     assertEq(orderID, 1);
//     //     Order memory order = productContract.getOrder(orderID);
//     //     assertEq(order.totalPrice, totalPrice);

//     //     executeOrder(orderID, totalPrice);
//     // }

//     function executeOrder1() internal returns (uint256){
//         uint256 quantity1 = 3;
//         uint256 quantity2 = 4;
//         address user1 = address(1);
//         vm.startPrank(user1);
//         addItemToCart(1, quantity1);
//         addItemToCart(2, quantity2);

//         warpTime(TIME);
//         Cart memory newCart1 = productContract.getUserCart();
//         assertEq(newCart1.id, 1);

//         vm.stopPrank();
//         CreateOrderParams[] memory params = _tempGenerateCreateOrderParams();

//         ShippingParams memory shippingParams = generateShippingParams();
//         uint256 totalPrice = productContract.getProduct(1).params.vipPrice *
//             quantity1 +
//             productContract.getProduct(2).params.vipPrice *
//             quantity2;

//         vm.prank(Sender);
//         USDT_ERC.mintToAddress(address(0x19), totalPrice);
//         vm.prank(address(0x19));
//         USDT_ERC.approve(address(productContract), totalPrice);
//         vm.prank(address(0x19));
//         uint256 orderID = createOrder(
//             user1,
//             0,
//             "refCode1234",
//             params,
//             shippingParams,
//             CheckoutType.STORAGE
//         );

//         assertEq(orderID, 1);
//         Order memory order = productContract.getOrder(orderID);
//         assertEq(order.totalPrice, totalPrice);

//         // executeOrder(orderID, totalPrice);
//         return orderID;
//     }


//     function test_executeOrder1_Lock() public {
//         seedCategories(10);
//         create3CorrectProduct();

//         uint256 quantity1 = 3;
//         uint256 quantity2 = 4;
//         address user1 = address(1);
//         vm.startPrank(user1);
//         addItemToCart(1, quantity1);
//         addItemToCart(2, quantity2);

//         warpTime(TIME);
//         Cart memory newCart1 = productContract.getUserCart();
//         assertEq(newCart1.id, 1);
//         vm.stopPrank();
//         CreateOrderParams[] memory params = _tempGenerateCreateOrderParams();

//         ShippingParams memory shippingParams = generateShippingParams();
//         uint256 totalPrice = productContract.getProduct(1).params.vipPrice *
//             quantity1 +
//             productContract.getProduct(2).params.vipPrice *
//             quantity2;

//         vm.startPrank(pos);
//         bytes32 mockPaymentId = keccak256(abi.encodePacked("payment-id")); // Mock Payment Id (Real: Get From Pos Smart Contract)

//         bool success = createOrderLock(
//             user1,
//             0,
//             "refCode1234",
//             params,
//             shippingParams,
//             CheckoutType.STORAGE,
//             totalPrice,
//             mockPaymentId
//         );

//         assertTrue(success, "execute order id");
//         vm.stopPrank();
//     }

//     function _tempGenerateCreateOrderParams()
//         internal
//         returns (CreateOrderParams[] memory)
//     {
//         string[] memory discountCodes;
//         CreateOrderParams memory params1 = CreateOrderParams(
//             1,
//             3,
//             1,
//             discountCodes
//         );
//         CreateOrderParams memory params2 = CreateOrderParams(
//             2,
//             4,
//             2,
//             discountCodes
//         );
//         CreateOrderParams[] memory params = new CreateOrderParams[](2);
//         params[0] = params1;
//         params[1] = params2;
//         return params;
//     }
//     //

//     function executeOrder2() public returns (uint256){
       
//         uint256 quantity1 = 5;
//         uint256 quantity2 = 10;
//         address user1 = address(1);

//         vm.startPrank(user1);
//         addItemToCart(2, quantity1);
//         addItemToCart(3, quantity2);

//         warpTime(TIME);
//         Cart memory newCart1 = productContract.getUserCart();
//         assertEq(newCart1.id, 1);
//         vm.stopPrank();
//         CreateOrderParams[] memory params = tempGenerateCreateOrderParams2();

//         ShippingParams memory shippingParams = generateShippingParams();
//         uint256 totalPrice = productContract.getProduct(2).params.vipPrice *
//             quantity1 +
//             productContract.getProduct(3).params.vipPrice *
//             quantity2;

//         vm.prank(Sender);
//         USDT_ERC.mintToAddress(address(0x19), totalPrice);
//         vm.prank(address(0x19));
//         USDT_ERC.approve(address(productContract), totalPrice);
//         vm.prank(address(0x19));
//         uint256 orderID = createOrder(
//             user1,
//             0,
//             "refCode1234",
//             params,
//             shippingParams,
//             CheckoutType.STORAGE
//         );

//         assertEq(orderID, 2);
//         Order memory order = productContract.getOrder(orderID);
//         assertEq(order.totalPrice, totalPrice);
//         // executeOrder(orderID, totalPrice);
//         return orderID;
//     }

//     function test_executeOrder2() public {
//         seedCategories(10);
//         create3CorrectProduct();
//         uint256 quantity1 = 5;
//         uint256 quantity2 = 10;
//         address user1 = address(1);

//         vm.startPrank(user1);
//         addItemToCart(2, quantity1);
//         addItemToCart(3, quantity2);

//         warpTime(TIME);
//         Cart memory newCart1 = productContract.getUserCart();
//         assertEq(newCart1.id, 1);
//         vm.stopPrank();
//         CreateOrderParams[] memory params = _tempGenerateCreateOrderParams2();

//         ShippingParams memory shippingParams = generateShippingParams();
//         uint256 totalPrice = productContract.getProduct(2).params.vipPrice *
//             quantity1 +
//             productContract.getProduct(3).params.vipPrice *
//             quantity2;

//         vm.prank(Sender);
//         USDT_ERC.mintToAddress(address(0x19), totalPrice);
//         vm.prank(address(0x19));
//         USDT_ERC.approve(address(productContract), totalPrice);
//         vm.prank(address(0x19));
//         uint256 orderID = createOrder(
//             user1,
//             0,
//             "refCode1234",
//             params,
//             shippingParams,
//             CheckoutType.STORAGE
//         );

//         assertEq(orderID, 1);
//         Order memory order = productContract.getOrder(orderID);
//         assertEq(order.totalPrice, totalPrice);
//         // executeOrder(orderID, totalPrice);
//     }

//     function tempGenerateCreateOrderParams2()
//         internal
//         returns (CreateOrderParams[] memory)
//     {
//         string[] memory discountCodes;
//         CreateOrderParams memory params1 = CreateOrderParams(
//             2,
//             5,
//             3,
//             discountCodes
//         );
//         CreateOrderParams memory params2 = CreateOrderParams(
//             3,
//             10,
//             4,
//             discountCodes
//         );
//         CreateOrderParams[] memory params = new CreateOrderParams[](2);
//         params[0] = params1;
//         params[1] = params2;
//         return params;
//     }

//     function _tempGenerateCreateOrderParams2()
//         internal
//         returns (CreateOrderParams[] memory)
//     {
//         string[] memory discountCodes;
//         CreateOrderParams memory params1 = CreateOrderParams(
//             2,
//             5,
//             1,
//             discountCodes
//         );
//         CreateOrderParams memory params2 = CreateOrderParams(
//             3,
//             10,
//             2,
//             discountCodes
//         );
//         CreateOrderParams[] memory params = new CreateOrderParams[](2);
//         params[0] = params1;
//         params[1] = params2;
//         return params;
//     }

//     function test_executeOrder3() public {
//         seedCategories(10);
//         create3CorrectProduct();
//         uint256 quantity1 = 5;
//         uint256 quantity2 = 4;

//         address user1 = address(1);

//         vm.startPrank(user1);
//         addItemToCart(2, quantity1);
//         addItemToCart(3, quantity2);
//         warpTime(TIME);
//         Cart memory newCart1 = productContract.getUserCart();
//         assertEq(newCart1.id, 1);
//         vm.stopPrank();
//         CreateOrderParams[] memory params = _tempGenerateCreateOrderParams3();

//         ShippingParams memory shippingParams = generateShippingParams();
//         uint256 totalPrice = productContract.getProduct(2).params.vipPrice *
//             quantity1 +
//             productContract.getProduct(3).params.vipPrice *
//             quantity2;

//         vm.prank(Sender);
//         USDT_ERC.mintToAddress(address(0x19), totalPrice);
//         vm.prank(address(0x19));
//         USDT_ERC.approve(address(productContract), totalPrice);
//         vm.prank(address(0x19));
//         uint256 orderID = createOrder(
//             user1,
//             0,
//             "refCode1234",
//             params,
//             shippingParams,
//             CheckoutType.RECEIVE
//         );

//         assertEq(orderID, 1);
//         Order memory order = productContract.getOrder(orderID);
//         assertEq(order.totalPrice, totalPrice);
//         // executeOrder(orderID, totalPrice);
//     }

//     function _tempGenerateCreateOrderParams3()
//         internal
//         returns (CreateOrderParams[] memory)
//     {
//         string[] memory discountCodes;
//         CreateOrderParams memory params1 = CreateOrderParams(
//             2,
//             5,
//             1,
//             discountCodes
//         );
//         CreateOrderParams memory params2 = CreateOrderParams(
//             3,
//             4,
//             2,
//             discountCodes
//         );
//         CreateOrderParams[] memory params = new CreateOrderParams[](2);
//         params[0] = params1;
//         params[1] = params2;
//         return params;
//     }

//     function test_executeOrder4() public {
//         seedCategories(10);
//         create3CorrectProduct();

//         address user1 = address(1);
//         vm.startPrank(user1);
//         addItemToCart(1, 2);
//         addItemToCart(3, 7);
//         vm.stopPrank();
//     }

//     function _tempGenerateCreateOrderParams4()
//         internal
//         returns (CreateOrderParams[] memory)
//     {
//         string[] memory discountCodes;
//         CreateOrderParams memory params1 = CreateOrderParams(
//             1,
//             2,
//             1,
//             discountCodes
//         );
//         CreateOrderParams memory params2 = CreateOrderParams(
//             3,
//             7,
//             2,
//             discountCodes
//         );
//         CreateOrderParams[] memory params = new CreateOrderParams[](2);
//         params[0] = params1;
//         params[1] = params2;
//         return params;
//     }

//     function test_executeOrder5() public {}

//     function generateCreateOrderParams1()
//         public
//         pure
//         returns (CreateOrderParams[] memory)
//     {
//         string[] memory discountCodes;
//         CreateOrderParams memory params1 = CreateOrderParams(
//             3,
//             1,
//             3,
//             discountCodes
//         );
//         CreateOrderParams memory params2 = CreateOrderParams(
//             4,
//             1,
//             4,
//             discountCodes
//         );

//         CreateOrderParams[] memory params = new CreateOrderParams[](2);
//         params[0] = params1;
//         params[1] = params2;

//         return params;
//     }

//     function generateShippingParams() public returns (ShippingParams memory) {
//         ShippingParams memory shippingParams = ShippingParams({
//             firstName: "First Name",
//             lastName: "Last Name",
//             email: "meta-node-ecomerce@example.com",
//             country: "Viet Nam",
//             city: "Ho Chi Minh",
//             stateOrProvince: "Ho Chi Minh",
//             postalCode: "10001",
//             phone: "+1 (555) 123-4567",
//             addressDetail: "123 Main Street"
//         });

//         return shippingParams;
//     }

//     function generateCreateProductParams(
//         bool invalidCategory
//     ) internal returns (createProductParams memory params) {
//         // Make sure at least exist one category if invalidCategory = false
//         if (!invalidCategory) {
//             (
//                 string memory testName,
//                 string memory testDescription,
//                 string[] memory testUrls
//             ) = seedCategory();
//             vm.prank(Sender);
//             productContract.createCategory(testName, testDescription);
//         }

//         //(reward=46,memberPrice=100)
//         //(reward=93,memberPrice=200)
//         //(reward=139,memberPrice=300)

//         bytes[] memory size = new bytes[](4);
//         size[0] = "S";
//         size[1] = "M";
//         size[2] = "L";
//         size[3] = "XL";

//         bytes[] memory color = new bytes[](4);
//         color[0] = "red";
//         color[1] = "blue";
//         color[2] = "black";
//         color[3] = "red";

//         uint256[] memory capacity = new uint256[](3);
//         capacity[0] = 120;
//         capacity[1] = 130;
//         capacity[2] = 140;

//         params.name = "Test Product";
//         params.categoryID = 1;
//         params.retailPrice = 100;
//         params.vipPrice = 2000;
//         params.memberPrice = 100;
//         params.reward = 46;
//         params.capacity = capacity; // 150ml
//         params.size = size; // 150ml
//         params.quantity = 100;
//         params.color = color;
//         params.retailer = address(0x6969); // Retailer's address
//         params.brandName = "Test Brand BeEarning";
//         params.shippingFee = 5;
//         params.warranty = "this is a warranty";
//         bytes[] memory testProductUrls = new bytes[](2);
//         testProductUrls[0] = "http://example.com/image1.png";
//         testProductUrls[1] = "http://example.com/image2.png";
//         params.images = testProductUrls;
//         params.videoUrl = "http://example.com/video.mp4";
//         params.expiryTime = block.timestamp + 365 days; // Expiry after 1 year
//         params.activateTime = block.timestamp + 1 days;
//         params.isMultipleDiscount = false;
//     }

//     function create3CorrectProduct() internal {
//         uint256 totalProduct = 3;
//         createProductParams[] memory params = new createProductParams[](
//             totalProduct
//         );

//         bytes[] memory size = new bytes[](4);
//         size[0] = "S";
//         size[1] = "M";
//         size[2] = "L";
//         size[3] = "XL";

//         uint256[] memory capacity = new uint256[](3);
//         capacity[0] = 120;
//         capacity[1] = 130;
//         capacity[2] = 140;

//         params[0].name = "Product1";
//         params[0].categoryID = 1;
//         params[0].retailPrice = 335 * ONE_USDT;
//         params[0].vipPrice = 308 * ONE_USDT;
//         params[0].memberPrice = (2345 * ONE_USDT) / 10;
//         params[0].reward = (5901 * ONE_USDT) / 100;
//         params[0].capacity = capacity; // 150ml
//         params[0].size = size; // 150ml
//         params[0].quantity = 100;
//         params[0].color = new bytes[](0);
//         params[0].retailer = Retailer1; // Retailer's address
//         params[0].brandName = "Test Brand BeEarning";
//         params[0].shippingFee = 5;
//         params[0].warranty = "this is a warranty";
//         bytes[] memory testProductUrls = new bytes[](2);
//         testProductUrls[0] = "http://example.com/image1.png";
//         testProductUrls[1] = "http://example.com/image2.png";
//         params[0].images = testProductUrls;
//         params[0].videoUrl = "http://example.com/video.mp4";
//         params[0].expiryTime = block.timestamp + 365 days; // Expiry after 1 year
//         params[0].activateTime = block.timestamp + 1 days;
//         params[0].isMultipleDiscount = false;

//         params[1].name = "Product2";
//         params[1].categoryID = 1;
//         params[1].retailPrice = 205 * ONE_USDT;
//         params[1].vipPrice = 188 * ONE_USDT;
//         params[1].memberPrice = (1435 * ONE_USDT) / 10;
//         params[1].reward = (3522 * ONE_USDT) / 100;
//         params[1].capacity = capacity; // 150ml
//         params[1].size = size; // 150ml
//         params[1].quantity = 100;
//         params[1].color = new bytes[](0);
//         params[1].retailer = Retailer1; // Retailer's address
//         params[1].brandName = "Test Brand BeEarning";
//         params[1].shippingFee = 5;
//         params[1].warranty = "this is a warranty";
//         params[1].images = testProductUrls;
//         params[1].videoUrl = "http://example.com/video.mp4";
//         params[1].expiryTime = block.timestamp + 365 days; // Expiry after 1 year
//         params[1].activateTime = block.timestamp + 1 days;
//         params[1].isMultipleDiscount = false;

//         params[2].name = "Product2";
//         params[2].categoryID = 1;
//         params[2].retailPrice = 355 * ONE_USDT;
//         params[2].vipPrice = 326 * ONE_USDT;
//         params[2].memberPrice = (2485 * ONE_USDT) / 10;
//         params[2].reward = (6266 * ONE_USDT) / 100;
//         params[2].capacity = capacity; // 150ml
//         params[2].size = size; // 150ml
//         params[2].quantity = 100;
//         params[2].color = new bytes[](0);
//         params[2].retailer = Retailer1; // Retailer's address
//         params[2].brandName = "Test Brand BeEarning";
//         params[2].shippingFee = 5;
//         params[2].warranty = "this is a warranty";
//         params[2].images = testProductUrls;
//         params[2].videoUrl = "http://example.com/video.mp4";
//         params[2].expiryTime = block.timestamp + 365 days; // Expiry after 1 year
//         params[2].activateTime = block.timestamp + 1 days;
//         params[2].isMultipleDiscount = false;

//         for (uint i = 0; i < totalProduct; i++) {
//             vm.prank(Controller);
//             uint256 productID = productContract.createProduct(params[i]);
//             assertEq(productID, i + 1);
//         }
//     }
   
//     function test_createShareLink() public{
//         seedCategories(10);
//         create3CorrectProduct();
//         // Order1 have
//         // productIds[1,2]
//         // quantities[3,4]
//         uint256 parentOrderID1 = executeOrder1();

//         // Order2 have
//         // productIds[2,3]
//         // quantities[5,10]
//         uint256 parentOrderID2 = executeOrder2();

//         Order memory parentOrder1 = productContract.getOrder(parentOrderID1);
//         Order memory parentOrder2 = productContract.getOrder(parentOrderID2);

//         ProductContract.ShareLinkParams memory params = createShareLinkParams(
//           parentOrder1.productIds,
//           parentOrder1.quantities,
//           parentOrderID1
//         );

//         ProductContract.ShareLinkParams memory params2 = createShareLinkParams(
//           parentOrder2.productIds,
//           parentOrder2.quantities,
//           parentOrderID2
//         );

//         ProductContract.ShareLinkParams[] memory newParams = new ProductContract.ShareLinkParams[](2);
//         newParams[0] = params;
//         newParams[1] = params2;
        
//         vm.prank(address(1));
//         uint256 id = productContract.createShareLink(newParams, TIME);

//         vm.prank(address(1));
//         ProductContract.ShareLink memory data = productContract.getShareLink(id);
//         // assertTrue(data.ID == 0, "id equal 0");
//         assertEq(data.params[0].productIds, parentOrder1.productIds);

//          uint256 totalPrice;
//         for (uint i = 0; i < data.params.length; i++) {
//             for (uint j = 0; j < data.params[i].productIds.length; j++) {
//                 totalPrice += data.params[i].prices[j] * data.params[i].quantities[j];
//             }
//         }

//         vm.prank(Sender);
//         USDT_ERC.mintToAddress(address(12341234), totalPrice);
//         vm.startPrank(address(12341234));
//         USDT_ERC.approve(address(productContract), totalPrice);

//         uint256 newOrderID = productContract.createOrderByStorageOrder(
//             data.ID,
//             address(1),
//             generateShippingParams(),
//             PaymentType.METANODE
//         );
//         vm.stopPrank();
//         Order memory parentOrder3 = productContract.getOrder(parentOrderID1);
//         Order memory parentOrder4 = productContract.getOrder(parentOrderID2);
//         Order memory newOrder = productContract.getOrder(newOrderID);

//         assertEq(newOrder.orderID, newOrderID);
//         // assertTrue(newOrderID, 3, "success??");
//     }
    
//     function test_createShareLink2() public{
//         seedCategories(10);
//         create3CorrectProduct();

//         // Execute orders
//         // Order1: productIds [1, 2], quantities [3, 4]
//         uint256 parentOrderID1 = executeOrder1();
//         // Order2: productIds [2, 3], quantities [5, 10]
//         uint256 parentOrderID2 = executeOrder2();

//         // Get initial orders
//         Order memory parentOrder1 = productContract.getOrder(parentOrderID1);
//         Order memory parentOrder2 = productContract.getOrder(parentOrderID2);

//         ProductContract.ShareLinkParams memory params = createShareLinkParams(
//           parentOrder1.productIds,
//           parentOrder1.quantities,
//           parentOrderID1
//         );
//         params.quantities[0] = 2; // Take 2 from product 1
//         params.quantities[1] = 1; // Take 1 from product 2

//         ProductContract.ShareLinkParams memory params2 = createShareLinkParams(
//           parentOrder2.productIds,
//           parentOrder2.quantities,
//           parentOrderID2
//         );

//         params2.quantities[0] = 3; // Take 3 from product 2
//         params2.quantities[1] = 7; // Take 7 from product 3

//         ProductContract.ShareLinkParams[] memory newParams = new ProductContract.ShareLinkParams[](2);
//         newParams[0] = params;
//         newParams[1] = params2;

//         warpTime(TIME);
//         vm.prank(address(1));
//         uint256 id = productContract.createShareLink(newParams,block.timestamp);

//         vm.prank(address(1));
//         ProductContract.ShareLink memory shareLinkData = productContract.getShareLink(id);

//         // Verify share link creation
//         assertTrue(shareLinkData.ID > 0, "share link exists");

//         // Verify the quantities and product IDs in the share link
//         assertEq(shareLinkData.params[0].productIds, parentOrder1.productIds, "Product IDs for order 1 are correct");
//         assertEq(shareLinkData.params[0].quantities[0], 2, "Quantity for product 1 in share link (order 1) is correct");
//         assertEq(shareLinkData.params[0].quantities[1], 1, "Quantity for product 2 in share link (order 1) is correct");

//         assertEq(shareLinkData.params[1].productIds, parentOrder2.productIds, "Product IDs for order 2 are correct");
//         assertEq(shareLinkData.params[1].quantities[0], 3, "Quantity for product 2 in share link (order 2) is correct");
//         assertEq(shareLinkData.params[1].quantities[1], 7, "Quantity for product 3 in share link (order 2) is correct");
//     }

//     function createShareLinkParams(uint256[] memory productIds, uint256[] memory quantities, uint256 _parentOrderID) internal returns (ProductContract.ShareLinkParams memory){
//         uint256[] memory prices = new uint256[](2); 
//         prices[0] = 100 * ONE_USDT;
//         prices[1] = 202 * ONE_USDT;
//         ProductContract.ShareLinkParams memory params = ProductContract.ShareLinkParams(
//           quantities,
//           productIds,
//           prices,
//           _parentOrderID
//         );
//         return params;
//     }

//     function test_editShareLink1() public{
//          seedCategories(10);
//         create3CorrectProduct();
//         // Order1 have
//         // productIds[1,2]
//         // quantities[3,4]
//         uint256 parentOrderID1 = executeOrder1();

//         // Order2 have
//         // productIds[2,3]
//         // quantities[5,10]
//         uint256 parentOrderID2 = executeOrder2();

//         Order memory parentOrder1 = productContract.getOrder(parentOrderID1);
//         Order memory parentOrder2 = productContract.getOrder(parentOrderID2);

//         ProductContract.ShareLinkParams memory params = createShareLinkParams(
//           parentOrder1.productIds,
//           parentOrder1.quantities,
//           parentOrderID1
//         );

//         ProductContract.ShareLinkParams memory params2 = createShareLinkParams(
//           parentOrder2.productIds,
//           parentOrder2.quantities,
//           parentOrderID2
//         );

//         ProductContract.ShareLinkParams[] memory newParams = new ProductContract.ShareLinkParams[](2);
//         newParams[0] = params;
//         newParams[1] = params2;
//         warpTime(TIME);
//         vm.prank(address(1));
//         uint256 id = productContract.createShareLink(newParams,block.timestamp);

//         vm.prank(address(1));
//         ProductContract.ShareLink memory data = productContract.getShareLink(id);
       

//         // Order1 now have
//         // productIds[1,2]
//         // quantities[0,0]
//         Order memory afterParentOrder= productContract.getOrder(parentOrderID1);
//         assertEq(afterParentOrder.quantities[0], 0);
//         // Order1 now have
//         // productIds[2,3]
//         // quantities[0,0]
//         Order memory afterParentOrder1 = productContract.getOrder(parentOrderID2);
//         assertEq(afterParentOrder1.quantities[1], 0);
//         assertTrue(data.ID > 0, "sharelink exists");

//         ProductContract.ShareLinkParams[] memory updatedParams;

//         warpTime(TIME);
//         vm.prank(address(1));
//         bool updateSuccess = productContract.updateShareLink(
//           data.ID,
//           updatedParams,
//           block.timestamp
//         );
//         assertTrue(updateSuccess, "update fail");
//         // Order1 have
//         // productIds[1,2]
//         // quantities[3,4]
//         Order memory updatedParentOrder = productContract.getOrder(parentOrderID1);
//         // Order2 have
//         // productIds[2,3]
//         // quantities[5,10]
//         Order memory updatedParentOrder2 = productContract.getOrder(parentOrderID2);
//         assertEq(updatedParentOrder.quantities[1], 4);
//     }

//     function test_updateShareLink2() public{
//         seedCategories(10);
//         create3CorrectProduct();

//         // Execute orders
//         uint256 parentOrderID1 = executeOrder1();
//         uint256 parentOrderID2 = executeOrder2();

//         // Get initial orders
//         Order memory parentOrder1 = productContract.getOrder(parentOrderID1);
//         Order memory parentOrder2 = productContract.getOrder(parentOrderID2);

//         // Create ShareLinkParams for initial share link creation
//         ProductContract.ShareLinkParams memory params1 = createShareLinkParams(
//             parentOrder1.productIds,
//             parentOrder1.quantities,
//             parentOrderID1
//         );

//         ProductContract.ShareLinkParams memory params2 = createShareLinkParams(
//             parentOrder2.productIds,
//             parentOrder2.quantities,
//             parentOrderID2
//         );

//         ProductContract.ShareLinkParams[] memory newParams = new ProductContract.ShareLinkParams[](2);
//         newParams[0] = params1;
//         newParams[1] = params2;

//         // Create the share link
//         warpTime(TIME);
//         vm.prank(address(1));
//         uint256 shareLinkID = productContract.createShareLink(newParams, TIME);

//         // Get the created share link
//         vm.prank(address(1));
//         ProductContract.ShareLink memory shareLinkData = productContract.getShareLink(shareLinkID);

//         // Ensure the share link exists
//         assertTrue(shareLinkData.ID > 0, "share link exists");

//         // Updated params for the update test
//         ProductContract.ShareLinkParams memory updatedParams1 = createShareLinkParams(
//             parentOrder1.productIds,
//             parentOrder1.quantities,
//             parentOrderID1
//         );

//         ProductContract.ShareLinkParams memory updatedParams2 = createShareLinkParams(
//             parentOrder2.productIds,
//             parentOrder2.quantities,
//             parentOrderID2
//         );

//         // Update params to reduce specific quantities
//         updatedParams1.quantities[0] = 2;
//         updatedParams1.quantities[1] = 1;

//         updatedParams2.quantities[0] = 3;
//         updatedParams2.quantities[1] = 7;

//         // Create an array of updated ShareLinkParams
//         ProductContract.ShareLinkParams[] memory updatedParams = new ProductContract.ShareLinkParams[](2);
//         updatedParams[0] = updatedParams1;
//         updatedParams[1] = updatedParams2;

//         // Update the share link
//         warpTime(TIME);
//         vm.prank(address(1));
//         bool updateSuccess = productContract.updateShareLink(
//             shareLinkData.ID,
//             updatedParams,
//             TIME
//         );

//         // Ensure the update was successful
//         assertTrue(updateSuccess, "update success");

//         // Get the updated parent orders
//         Order memory updatedParentOrder1 = productContract.getOrder(parentOrderID1);
//         Order memory updatedParentOrder2 = productContract.getOrder(parentOrderID2);

//         // Verify the updated quantities
//         assertEq(updatedParentOrder1.quantities[0], 1, "Quantity for product 1 in parent order 1 is correct");
//         assertEq(updatedParentOrder1.quantities[1], 3, "Quantity for product 2 in parent order 1 is correct");

//         assertEq(updatedParentOrder2.quantities[0], 2, "Quantity for product 1 in parent order 2 is correct");
//         assertEq(updatedParentOrder2.quantities[1], 3, "Quantity for product 2 in parent order 2 is correct");
//     }

//     function test_deleteShareLink() public{
//         seedCategories(10);
//         create3CorrectProduct();

//         // Execute orderswarpTime(TIME)
//         // Order1: productIds [1, 2], quantities [3, 4]
//         uint256 parentOrderID1 = executeOrder1();
//         // Order2: productIds [2, 3], quantities [5, 10]
//         uint256 parentOrderID2 = executeOrder2();

//         // Get initial orders
//         Order memory parentOrder1 = productContract.getOrder(parentOrderID1);
//         Order memory parentOrder2 = productContract.getOrder(parentOrderID2);

//         ProductContract.ShareLinkParams memory params = createShareLinkParams(
//           parentOrder1.productIds,
//           parentOrder1.quantities,
//           parentOrderID1
//         );
//         params.quantities[0] = 2; // Take 2 from product 1
//         params.quantities[1] = 1; // Take 1 from product 2

//         ProductContract.ShareLinkParams memory params2 = createShareLinkParams(
//           parentOrder2.productIds,
//           parentOrder2.quantities,
//           parentOrderID2
//         );

//         params2.quantities[0] = 3; // Take 3 from product 2
//         params2.quantities[1] = 7; // Take 7 from product 3

//         ProductContract.ShareLinkParams[] memory newParams = new ProductContract.ShareLinkParams[](2);
//         newParams[0] = params;
//         newParams[1] = params2;
//         warpTime(TIME);
//         vm.startPrank(address(1));
//         uint256 id = productContract.createShareLink(newParams,TIME);

//         ProductContract.ShareLink memory shareLinkData = productContract.getShareLink(id);

//         assertTrue(shareLinkData.ID > 0, "get success");

//         bool deleteSuccess = productContract.deleteShareLink(id);
//         assertTrue(deleteSuccess, "delete success?");
        
//         ProductContract.ShareLink memory shareLinkData1 = productContract.getShareLink(id);
//         vm.stopPrank();
//         assertTrue(shareLinkData1.ID == 0, "????");
//     }

//     function seedCategory()
//         internal
//         pure
//         returns (
//             string memory testName,
//             string memory testDescription,
//             string[] memory testUrls
//         )
//     {
//         testName = "Test Category";
//         testDescription = "This is a test category.";
//         testUrls = new string[](2);
//         testUrls[0] = "http://example.com/image1.png";
//         testUrls[1] = "http://example.com/image2.png";

//         return (testName, testDescription, testUrls);
//     }

//     function seedCategories(uint count) public {
//         vm.startPrank(Sender);
//         for (uint i = 0; i < count; i++) {
//             string memory name = string.concat(
//                 "Category ",
//                 Strings.toString(i)
//             );
//             string memory description = string.concat(
//                 "Description for Category ",
//                 Strings.toString(i)
//             );
//             productContract.createCategory(name, description);
//         }
//         vm.stopPrank();
//     }

//     function seedProducts(
//         uint productCounts
//     )
//         internal
//         returns (createProductParams[] memory, string[] memory, string[] memory)
//     {
//         uint categoryCounts = 2;
//         uint brandNameCounts = 4;

//         string[] memory category = new string[](categoryCounts);
//         category[0] = productContract.getCategory(1).name;
//         category[1] = productContract.getCategory(2).name;

//         string[] memory brandNames = new string[](brandNameCounts);
//         brandNames[0] = "Brand 1";
//         brandNames[1] = "Brand 2";
//         brandNames[2] = "Brand 3";
//         brandNames[3] = "Brand 4";

//         bytes[] memory size = new bytes[](4);

//         size[0] = "S";
//         size[1] = "M";
//         size[2] = "L";
//         size[3] = "XL";

//         uint256[] memory capacity = new uint256[](3);
//         capacity[0] = 120;
//         capacity[1] = 130;
//         capacity[2] = 140;

//         uint idxCategory = 0;
//         uint idxBrandName = 0;
//         uint256 retailPrice = 150 * ONE_USDT;

//         bytes[] memory color = new bytes[](4);
//         color[0] = "red";
//         color[1] = "blue";
//         color[2] = "black";
//         color[3] = "red";

//         createProductParams[] memory productParams = new createProductParams[](
//             productCounts
//         );

//         for (uint i = 0; i < productCounts; i++) {
//             string memory idxProduct = Strings.toString(i);
//             createProductParams memory params;
//             // Shuffle category, retailPrice, brand name
//             params.name = string.concat("Test Product ", idxProduct);
//             params.categoryID = idxCategory + 1;
//             params.retailPrice = retailPrice;
//             params.brandName = brandNames[idxBrandName];

//             params.vipPrice = 308 * ONE_USDT;
//             params.memberPrice = (2345 * ONE_USDT) / 10;
//             params.reward = (5901 * ONE_USDT) / 100;
//             if (i % 2 == 0) {
//                 params.vipPrice = 188 * ONE_USDT;
//                 params.memberPrice = (1435 * ONE_USDT) / 10;
//                 params.reward = (3522 * ONE_USDT) / 100;
//             }
//             params.capacity = capacity;
//             params.size = size;
//             params.quantity = 100;
//             params.color = color;

//             if (i % 2 == 0) {
//                 params.retailer = Retailer1; // Retailer's address
//             } else {
//                 params.retailer = Retailer2;
//             }

//             bytes[] memory testProductUrls = new bytes[](2);
//             testProductUrls[0] = "http://example.com/image1.png";
//             testProductUrls[1] = "http://example.com/image2.png";
//             params.images = testProductUrls;

//             params.videoUrl = "http://example.com/video.mp4";
//             params.expiryTime = block.timestamp + 365 days; // Expiry after 1 year
//             params.activateTime = block.timestamp + 1 days;
//             params.isMultipleDiscount = false;
//             params.shippingFee = 5;
//             params.warranty = "this is a warranty";

//             vm.prank(Controller);
//             productContract.createProduct(params);

//             idxCategory = (idxCategory + 1) % categoryCounts;
//             idxBrandName = (idxBrandName + 1) % brandNameCounts;
//             retailPrice += 1e3;

//             productParams[i] = params;
//         }
//         return (productParams, brandNames, category);
//     }

//     function convertUint256ToAddress(
//         uint256 _num
//     ) internal pure returns (address) {
//         return address(uint160(_num + 1));
//     }
// }
