// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.0;

abstract contract AbstractEcom {
    enum TrackUserType {
        PAYOUT, //0
        SHIPPING //1
    }
    enum PaymentType {
        VISA,
        METANODE
    }

    enum DiscountType {
        ALL, //0
        PRODUCT, //1
        CATEGORY //2
    }

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
        uint256 retailPrice;
        uint256 vipPrice;
        uint256 memberPrice;
        uint256 reward;
        uint256 capacity; // 150ml
        uint256 quantity;
        string color;
        address retailer;
        string brandName;
        string[] images;
        string videoUrl;
        uint256 expiryTime;
        uint256 activateTime;
        bool isMultipleDiscount;
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
        string[] imageUrls;
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

    struct SearchTrend {
        uint256 timestamp;
        uint8 count;
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

    struct Comment {
        uint256 id;
        // If parentID == 0; it's a comment else it's a reply
        uint256 parentID;
        address user;
        string message;
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
    }

    struct Purchase {
        uint256 productID;
        uint256 buyAt;
    }

    struct ListTrackUser {
        string orderID;
        uint8 trackType;
        address customer;
        uint256[] productIds;
        uint256[] quantities;
    }

    struct createListTrackUserParams {
        string orderID;
        uint8 trackType;
        address customer;
        uint256[] productIds;
        uint256[] quantities;
    }

    struct AddedToCartAndWishList {
        address customer;
        uint256[] productIds;
        uint256[] quantities;
        uint256[] addedAt;
    }

    struct PaymentHistory {
        uint8 paymentType;
        uint256 totalPayment;
    }

    struct Discount {
        string discountCode;
        DiscountType discountType;
        uint256 discountPercentage; // div 1000 0.5% -> 5, 50% -> 500
        uint256 maximumDiscountAmount;
        uint256 discountAmount;
        uint256 necessaryAmount; // necessary amount to discount. discount 8% on order of 1million..
        uint256 startDate;
        uint256 endDate;
    }

    struct createDiscountParams {
        string discountCode;
        DiscountType discountType;
        uint256 id; //Either productID or category id
        uint256 maximumDiscountAmount;
        uint256 discountPercentage;
        uint256 discountAmount;
        uint256 necessaryAmount;
        uint256 startDate;
        uint256 endDate;
    }

    struct editDiscountParams {
        string discountCode; //Wont edit
        uint256 id; //Wont edit, categoryID or productID base on type
        uint256 maximumDiscountAmount;
        uint256 discountPercentage;
        uint256 discountAmount;
        uint256 necessaryAmount;
        uint256 startDate;
        uint256 endDate;
    }
}
