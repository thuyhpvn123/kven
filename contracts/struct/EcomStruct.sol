// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

struct Product {
    uint256 id;
    // avoid stack too deep;
    // TODO: change name in the future;
    createProductParams params;
    uint256 createdAt;
    uint256 updatedAt;
}

struct createProductParams {
    string name;
    uint256 categoryID;
    string description;
    uint256 shippingFee;
    address retailer;
    string brandName;
    string warranty;
    bool isFlashSale;
    bytes[] images;
    string videoUrl;
    bool isApprove;
    uint256 sold;
    uint256 boostTime;
    uint256 expiryTime;
    uint256 flashSaleExpiryTime;
    uint256 activateTime;
    bool isMultipleDiscount;
}

struct VariantParams{
    bytes32 variantID;
    Attribute[] attrs;
    Pricing priceOptions;
}

struct Variant{
    bytes32 variantID;
    Pricing priceOptions;
}

struct Attribute{
    bytes32 id;
    string key; //Color
    string value; // Red
}

struct Pricing {
    uint256 retailPrice;
    uint256 vipPrice;
    uint256 memberPrice;
    uint256 reward;
    uint256 quantity;
}
struct getAllProductsParams {
    string categoryName;
    string brandName;
    uint256 fromPrice;
    uint256 toPrice;
    bool priceDESC;
    bool priceASC;
    bool nameDESC;
    bool nameASC;
    bool timestampDESC;
    bool timestampASC;
}

struct Retailer {
    address retailer;
    string telegramUsername;
    string telegramUserID;
}

struct Category {
    uint256 id;
    string name;
    string description;
}

struct ShippingInfo {
    uint256 id;
    uint256 orderID;
    address userAddress;
    ShippingParams params;
}

struct ShippingParams {
    string firstName;
    string lastName;
    string email;
    string country;
    string city;
    string stateOrProvince;
    string postalCode;
    string phone;
    string addressDetail;
}

struct FAQ {
    uint256 id;
    string title;
    string content;
}

struct FlashSale {
    uint256 id;
    uint256 startDate;
    uint256 endDate;
    uint256 retailPrice;
    uint256 vipPrice;
    uint256 memberPrice;
    uint256 reward;
    uint256 productID;
}

enum CommentType {
    REVIEW,
    PRESSCOMMENT
}

struct Comment {
    uint256 id;
    address user;
    string name;
    string message;
    uint8 commentType;
    uint256 createdAt;
    uint256 updatedAt;
    uint256 productID;
}

struct Rating {
    uint256 id;
    address user;
    uint rateValue;
    uint256 createdAt;
}

struct RateValue {
    bool isRated;
    uint rateValue;
}

struct BestSeller {
    uint256 productID;
    uint256 sold;
    uint256 timestamp;
}

struct Purchase {
    uint256 productID;
    uint256 buyAt;
}

enum TrackUserType {
    PAYOUT, //0
    SHIPPING //1
}

struct ListTrackUser {
    string orderID;
    uint8 trackType;
    address customer;
    bytes retailerName;
    uint256 timestamp;
    uint256[] productIds;
    uint256[] quantities;
}

struct DecodedParams {
    CreateOrderParams[] params;
    ShippingParams shippingParams;
    address user;
    orderDetails details;
  }

struct createListTrackUserParams {
    string orderID;
    uint8 trackType;
    address customer;
    uint256[] productIds;
    uint256[] quantities;
}

enum TrackActivityType{
    CART,
    WISHLIST
}

struct AddedToCartAndWishList {
    address customer;
    uint8 activityType;
    uint256[] productIds;
    uint256[] quantities;
    uint256[] addedAt;
}

struct PaymentHistory {
    uint8 paymentType;
    uint256 totalPayment;
    address buyer;
}

enum EProductType{
    ALL,
    FLASHSALE,
    NEWPRODUCT
}

enum EPrice{
    ASC,
    DESC
}

enum EDatePost{
    ASC,
    DESC
}

enum EStatus{
    ALL,
    PENDING,
    APPROVE
}

struct getProductManagementParams{
    EProductType _productType;
    EPrice _price;
    EDatePost _datePost;
    EStatus _status;
    address _retailer;
    string _term;
    uint256 _from; // from time
    uint256 _to; // to time
    uint256 page;
    uint256 perPage;
}
struct ProductInfo {
    Product product;
    Variant[] variants;
    Attribute[][] attributes;
}

struct CartItem {
    uint256 id;
    uint256 productID;
    uint256 quantity;
    bytes32 variantID;
    uint256 createdAt;
}

struct Cart {
    uint256 id;
    address owner;
    CartItem[] items;
}


struct AddItemToCartParams {
    uint256 _productID;
    bytes32 _variantID;
    uint256 quantity;
}

struct UpdateItemsToCartParams {
    uint256 itemID;
    uint256 quantity;
}

struct CreateOrderParams {
    uint256 productID;
    uint256 quantity;
    bytes32 variantID;
    uint256 cartItemId;
    string[] discountCodes;
}

struct CreateOrderStorageParams {
    uint256 productID;
    uint256 quantity;
    uint256 price;
}

struct orderDetails {
    uint256 totalPriceWithoutDiscount;
    bytes32 codeRef;
    CheckoutType checkoutType;
    PaymentType paymentType;
}

enum PaymentType {
    VISA,
    METANODE
}

enum CheckoutType {
    RECEIVE,
    STORAGE
}

enum OrderStatus {
    AWAITING,
    INTRANSIT,
    DELIVERED,
    CANCELLED,
    STORAGE
}

struct Order {
    uint256 orderID;
    address user;
    address buyer;
    uint256 discountID;
    uint256[] productIds;
    bytes32[] variantIds;
    uint256[] quantities;
    uint256[] prices;
    uint256[] cartItemIds;
    uint256[] afterPrices; //if it have discount, store discount price, else store normal price
    uint256 totalPrice;
    uint8 checkoutType;
    uint8 orderStatus;
    bytes32 codeRef;
    uint256 afterDiscountPrice;
    uint256 shippingPrice;
    uint8 paymentType;
    uint256 createdAt;
}

enum ROLE {
    ADMIN,
    CUSTOMER,
    RETAILER
}

enum POSPaymentType {
    CHECKOUT, // normal payment checkout
    SHARELINK // checkout with
}

struct AddressInfo {
    string country;
    string city;
    string state;
    string postalCode;
    string detailAddress;
}

struct UserInfo {
    address user;
    string fullName;
    string email;
    uint8 gender;
    uint256 dateOfBirth;
    string phoneNumber;
    string image;
    ROLE role;
    uint256 createdAt;
}

struct registerParams {
    string fullName;
    string email;
    uint8 gender;
    uint256 dateOfBirth;
    string phoneNumber;
}

struct NotificationSetting {
    bool NotificationEmail;
    bool OrderUpdate;
    bool PromotionalProgram;
    bool CreateProduct;
    bool CustomerOrderUpdate;
    bool CommentUpdate;
}

struct ShareLinkParams {
    uint256[] quantities;
    uint256[] productIds;
    bytes32[] variantIds;
    uint256[] prices;
    uint256 parentOrderID;
}

struct ShareLink {
    uint256 ID;
    ShareLinkParams[] params;
    address owner;
    bool isExecuted;
    uint256 expiredTime;
}

struct createCommentParams {
    CommentType commentType;
    string content;
    string name;
    uint256 rate;
}

struct editCommentsParam {
    uint256 commentID;
    string content;
}

struct createFaqParams {
    string title;
    string content;
}

struct editFAQsProductParam {
    uint256 faqID;
    string title;
    string content;
}

struct Favorite {
    uint256 productID;
    uint256 createdAt;
}
