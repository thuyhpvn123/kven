// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;
import "@openzeppelin/contracts@v4.9.0/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts@v4.9.0/token/ERC721/IERC721.sol";
import "./interfaces/IKventure.sol";
import "./interfaces/IKventureCode.sol";
import "./interfaces/IKventureOrder.sol";
import "./interfaces/IKventureProduct.sol";
import "./abstract/use_pos.sol";

contract KProduct is UsePos {
    bytes32[] public ListProductID;
    address[] public Admins;
    mapping(address => bool) public IsAdmin;
    // Address smc
    IERC20 public SCUsdt;
    IKventure public SCKven;
    IKventureCode public SCKvenCode;
    IOrder public SCOrder;

    address public MasterPool;
    address public Owner;

    mapping(bytes32 => Product) public mIDToProduct;

    uint8 public ReturnRIP = 10;
    bytes32[] public ActiveProduct;

    event SaleOrder(
        address buyer,
        bytes32 orderId,
        bytes32[] productIds,
        uint256[] quantities
    );
    struct EventInput {
        address add;
        uint256[] quantities;
        uint256[] prices;
        uint256 totalPrice;
        uint256 time;
        bytes32[] idArr;
        address from;
        address to;
        uint256 currentFrom;
        uint256 currentPool;
        bytes32 paymentID;
    }
    address public POS;
    event eBuyProduct(EventInput eventOrder);
    // event eBuyProduct(address add, uint256[] quantities, uint256[] prices,uint256 totalPrice, uint256 time,bytes32[] idArr);
    event eCodeTransaction(
        address from,
        address to,
        uint256 amount,
        string token,
        bytes32 codeHash,
        uint256 datePurchase
    );

    constructor() payable {
        Owner = msg.sender;
        SCUsdt = IERC20(address(0x0000000000000000000000000000000000000002));
        MasterPool = address(0x0D1c1592C2BAAc6Abcd731Bc93a620ddb8a9C8AA);
        SCKven = IKventure(address(0x623962CB631B56C1fb546136772e0EA516a21323));
        SCKvenCode = IKventureCode(
            address(0x3609d3a70C6b9B7eF26E317EE2A43c73fD633DC1)
        );
        SCOrder = IOrder(address(0x202ab19FD4E663D046C94C54626ac063a400F37C));
    }

    modifier onlyOwner() {
        require(
            Owner == msg.sender,
            '{"from": "KventureProduct.sol", "code": 1, "message": "Invalid caller-Only Owner"}'
        );
        _;
    }

    modifier onlyAdmin() {
        require(
            IsAdmin[msg.sender] == true, 
            '{"from": "KventureProduct.sol", "code": 2, "message": "Invalid caller-Only Admin"}'
        );
        _;
    }
    modifier onlyPOS() {
        require(
            msg.sender == POS,
            '{"from": "KventureProduct.sol", "code": 3, "message": "Only POS"}'
        );
        _;
    }

    function SetKventureCode(address _kventureCode) external onlyOwner {
        SCKvenCode = IKventureCode(_kventureCode);
    }

    function SetOrder(address _order) external onlyOwner {
        SCOrder = IOrder(_order);
    }

    function SetKventure(address _kventure) external onlyOwner {
        SCKven = IKventure(_kventure);
    }

    function SetUsdt(address _usdt) external onlyOwner {
        SCUsdt = IERC20(_usdt);
    }

    function SetAdmin(address _admin) external onlyOwner {
        IsAdmin[_admin] = true;
        Admins.push(_admin);
    }

    function SetPOS(address _pos) external onlyOwner {
        POS = _pos;
    }

    function RemoveAdmin(address _admin) external onlyOwner returns (bool) {
        IsAdmin[_admin] = false;
        for (uint256 i = 0; i < Admins.length; i++) {
            if (Admins[i] == _admin) {
                if (i < Admins.length - 1) {
                    Admins[i] = Admins[Admins.length - 1];
                }
                Admins.pop();
                return true;
            }
        }
        return true;
    }

    function SetMasterPool(address _masterPool) external onlyOwner {
        MasterPool = _masterPool;
    }

    function Order(
        OrderInput[] calldata orderInputs,
        address to
    ) external returns (bytes32) {
        // Payment and bonus tree flow
        OrderProduct[] memory orderProducts = new OrderProduct[](
            orderInputs.length
        );
        uint256[] memory prices = new uint256[](orderInputs.length);
        uint256 totalPrice;
        uint256[] memory quaArr = new uint256[](orderInputs.length);
        bytes32[] memory idArr = new bytes32[](orderInputs.length);
        for (uint i = 0; i < orderInputs.length; i++) {
            bytes32 id = orderInputs[i].id;
            require(
                mIDToProduct[id].memberPrice > 0,
                '{"from": "KventureProduct.sol", "code": 4, "message": "Invalid product ID or product does not exist"}'
            );
            // This is link price or member price
            prices[i] = mIDToProduct[id].memberPrice;
            // Loop because good sale pay in each product
            for (uint256 index = 0; index < orderInputs[i].quantity; index++) {
                // Sender transfer to master pool
                SCUsdt.transferFrom(
                    msg.sender,
                    MasterPool,
                    mIDToProduct[id].memberPrice
                );
                // Pay bonus
                SCKven.TransferCommssion(
                    to,
                    mIDToProduct[id].memberPrice,
                    mIDToProduct[id].reward,
                    mIDToProduct[id].retailPrice - mIDToProduct[id].memberPrice
                );
                SCKven.AddDiamondShare(to, mIDToProduct[id].memberPrice);
                // Total price to buy product
                totalPrice += mIDToProduct[id].memberPrice;
            }
            quaArr[i] = orderInputs[i].quantity;
            idArr[i] = orderInputs[i].id;
            orderProducts[i] = OrderProduct({
                desc: mIDToProduct[id].desc,
                imgUrl: mIDToProduct[id].imgUrl,
                price: mIDToProduct[id].memberPrice,
                boostTime: mIDToProduct[id].boostTime,
                quantity: orderInputs[i].quantity,
                retailPrice: mIDToProduct[id].retailPrice,
                tokens: new uint[](orderInputs[i].quantity)
            });
            // Create code if boost time > 0
            if (mIDToProduct[id].boostTime > 0) {
                GenCodeInput memory input = GenCodeInput(
                    to,
                    mIDToProduct[id].memberPrice,
                    orderInputs[i].quantity,
                    orderInputs[i].lock,
                    orderInputs[i].codeHashes,
                    orderInputs[i].delegate,
                    mIDToProduct[id].boostTime
                );
                orderProducts[i].tokens = _createCode(input);
            }
        }
        EventInput memory eventInput = EventInput({
            add: to,
            quantities: quaArr,
            prices: prices,
            totalPrice: totalPrice,
            time: block.timestamp,
            idArr: idArr,
            from: msg.sender,
            to: MasterPool,
            currentFrom: SCUsdt.balanceOf(msg.sender),
            currentPool: SCUsdt.balanceOf(MasterPool),
            paymentID: bytes32(0)
        });
        emit eBuyProduct(eventInput);
        require(
            SCKven.CheckActiveMember(to),
            '{"from": "KventureProduct.sol", "code": 5, "message": "Address is not an active member"}'
        );

        return SCOrder.CreateOrder(to, orderProducts);
    }

    function _createCode(
        GenCodeInput memory input
    ) internal returns (uint[] memory) {
        uint[] memory kq = SCKvenCode.GenerateCode(input);
        for (uint i = 0; i < input.quantity; i++) {
            emit eCodeTransaction(
                msg.sender,
                input.buyer,
                input.planPrice,
                "USDT",
                input.codeHashes[i],
                block.timestamp
            );
        }
        return kq;
    }

    function _createCodeLock(
        GenCodeInput memory input
    ) internal returns (uint[] memory) {
        uint[] memory kq = SCKvenCode.GenerateCodeLock(input);
        for (uint i = 0; i < input.quantity; i++) {
            emit eCodeTransaction(
                msg.sender,
                input.buyer,
                input.planPrice,
                "USDT",
                input.codeHashes[i],
                block.timestamp
            );
        }
        return kq;
    }

    function CallData(
        OrderInput[] memory _input,
        address _address
    ) public view returns (bytes memory callData) {
        return abi.encode(_input, _address);
    }

    //   OrderInput[] calldata orderLockInputs,
    //         address to
    function ExecuteOrder(
        bytes memory callData,
        bytes32 idPayment,
        uint256 paymentAmount
    ) public override onlyPOS returns (bool) {
        // Payment and bonus tree flow
        (OrderInput[] memory orderLockInputs, address to) = abi.decode(
            callData,
            (OrderInput[], address)
        );

        uint256 balBuyer = SCUsdt.balanceOf(msg.sender);
        uint256 balMas = SCUsdt.balanceOf(MasterPool);
        require(
            SCKven.CheckActiveMember(to), 
            '{"from": "KventureProduct.sol", "code": 6, "message": "Address is not an active member"}'
        );
        OrderProduct[] memory orderProducts = new OrderProduct[](
            orderLockInputs.length
        );
        uint256[] memory prices = new uint256[](orderLockInputs.length);
        uint256 totalPrice;
        uint256[] memory quaArr = new uint256[](orderLockInputs.length);
        bytes32[] memory idArr = new bytes32[](orderLockInputs.length);
        for (uint i = 0; i < orderLockInputs.length; i++) {
            bytes32 id = orderLockInputs[i].id;
            require(
                mIDToProduct[id].memberPrice > 0,
                '{"from": "KventureProduct.sol", "code": 7, "message": "Invalid product ID or product does not exist"}'
            );
            // This is link price or member price
            prices[i] = mIDToProduct[id].memberPrice;
            // Loop because good sale pay in each product
            for (
                uint256 index = 0;
                index < orderLockInputs[i].quantity;
                index++
            ) {
                // Pay bonus

                TransferComInput memory transferComIn;
                transferComIn.buyer = to;
                transferComIn.price = mIDToProduct[id].memberPrice;
                transferComIn.reward = mIDToProduct[id].reward;
                transferComIn.diff =
                    mIDToProduct[id].retailPrice -
                    mIDToProduct[id].memberPrice;
                transferComIn.idPayment = idPayment;
                SCKven.TransferCommssionSave(transferComIn);
                SCKven.AddDiamondShare(to, mIDToProduct[id].memberPrice);
                // Total price to buy product
                totalPrice += mIDToProduct[id].memberPrice;
            }
            quaArr[i] = orderLockInputs[i].quantity;
            idArr[i] = orderLockInputs[i].id;
            orderProducts[i] = OrderProduct({
                desc: mIDToProduct[id].desc,
                imgUrl: mIDToProduct[id].imgUrl,
                price: mIDToProduct[id].memberPrice,
                boostTime: mIDToProduct[id].boostTime,
                quantity: orderLockInputs[i].quantity,
                retailPrice: mIDToProduct[id].retailPrice,
                tokens: new uint[](orderLockInputs[i].quantity)
            });
            // Create code if boost time > 0
            if (mIDToProduct[id].boostTime > 0) {
                orderProducts[i].tokens = _gencode(to, orderLockInputs, id, i);
            }
        }
        require(
            paymentAmount >= totalPrice,
            '{"from": "KventureProduct.sol", "code": 8, "message": "Insufficient payment amount"}'
        );
        EventInput memory eventInput = EventInput({
            add: to,
            quantities: quaArr,
            prices: prices,
            totalPrice: totalPrice,
            time: block.timestamp,
            idArr: idArr,
            from: msg.sender,
            to: MasterPool,
            currentFrom: balBuyer,
            currentPool: balMas,
            paymentID: idPayment
        });
        emit eBuyProduct(eventInput);

        SCOrder.CreateOrder(to, orderProducts);

        return true;
    }

    function _gencode(
        address to,
        OrderInput[] memory orderLockInputs,
        bytes32 id,
        uint256 i
    ) internal returns (uint[] memory) {
        GenCodeInput memory input = GenCodeInput(
            to,
            mIDToProduct[id].memberPrice,
            orderLockInputs[i].quantity,
            orderLockInputs[i].lock,
            orderLockInputs[i].codeHashes,
            orderLockInputs[i].delegate,
            mIDToProduct[id].boostTime
        );

        return _createCodeLock(input);
    }

    function AdminAddProduct(
        string memory _imgUrl,
        uint256 _memberPrice,
        uint256 _retailPrice,
        string memory _desc,
        string memory _name,
        bool _status,
        uint256 _boostTime,
        uint256 _reward,
        uint256 _vipPrice
    ) external onlyAdmin {
        bytes32 idPro = keccak256(
            abi.encodePacked(_imgUrl, _memberPrice, _retailPrice, _desc)
        );

        mIDToProduct[idPro] = Product({
            id: idPro,
            imgUrl: bytes(_imgUrl),
            memberPrice: _memberPrice,
            retailPrice: _retailPrice,
            desc: bytes(_desc),
            name: bytes(_name),
            active: _status,
            boostTime: _boostTime,
            reward: _reward,
            vipPrice: _vipPrice,
            updateAt: block.timestamp
        });

        require(
            mIDToProduct[idPro].retailPrice >= mIDToProduct[idPro].memberPrice,
            '{"from": "KventureProduct.sol", "code": 9, "message": "member price is greater than retail price"}'
        );

        require(
            _reward <= (
                (
                    (mIDToProduct[idPro].memberPrice * 50) - 
                    (20 * (mIDToProduct[idPro].retailPrice - mIDToProduct[idPro].memberPrice))
                ) * 10 ** 3
            ) / (130 * 825),
            '{"from": "KventureProduct.sol", "code": 10, "message": "reward too big"}'
        );

        if (_status == true) {
            ActiveProduct.push(idPro);
        }

        ListProductID.push(idPro);
    }

    function AdminActiveProduct(bytes32 _id) external onlyAdmin returns (bool) {
        mIDToProduct[_id].active = true;
        for (uint256 i = 0; i < ActiveProduct.length; i++) {
            if (ActiveProduct[i] == _id) {
                return true;
            }
        }
        ActiveProduct.push(_id);
        return true;
    }

    function AdminDeactiveProduct(
        bytes32 _id
    ) external onlyAdmin returns (bool) {
        mIDToProduct[_id].active = false;
        for (uint256 i = 0; i < ActiveProduct.length; i++) {
            if (ActiveProduct[i] == _id) {
                if (i < ActiveProduct.length - 1) {
                    ActiveProduct[i] = ActiveProduct[ActiveProduct.length - 1];
                }
                ActiveProduct.pop();
                return true;
            }
        }
        return true;
    }

    function GetProductById(bytes32 _id) public view returns (Product memory) {
        return mIDToProduct[_id];
    }

    function AdminUpdateProductInfo(
        bytes32 _id,
        string memory _imgUrl,
        string memory _desc
    ) external onlyAdmin returns (bool) {
        Product storage product = mIDToProduct[_id];
        product.imgUrl = bytes(_imgUrl);
        product.desc = bytes(_desc);
        product.updateAt = block.timestamp;
        return true;
    }

    function AdminEditUpdateAt(
        bytes32 _id,
        uint256 _updateAt
    ) external onlyAdmin returns (bool) {
        mIDToProduct[_id].updateAt = _updateAt;
        return true;
    }

    function AdminViewProduct()
        external
        view
        onlyAdmin
        returns (Product[] memory _products)
    {
        _products = new Product[](ListProductID.length);
        for (uint i = 0; i < ListProductID.length; i++) {
            _products[i] = mIDToProduct[ListProductID[i]];
        }
        return _products;
    }

    function UserViewProduct()
        external
        view
        returns (Product[] memory _products)
    {
        _products = new Product[](ActiveProduct.length);
        for (uint i = 0; i < ActiveProduct.length; i++) {
            _products[i] = mIDToProduct[ActiveProduct[i]];
        }
        return _products;
    }

    function ViewProducts(
        uint256 _updateAt,
        uint256 _index,
        uint256 _limit
    ) external view returns (Product[] memory rs, bool isMore, uint lastIndex) {
        Product[] memory ps = new Product[](_limit);
        isMore = false;
        uint index;
        while (_index < ActiveProduct.length) {
            if (_updateAt <= mIDToProduct[ActiveProduct[_index]].updateAt) {
                if (index < _limit) {
                    ps[index] = mIDToProduct[ActiveProduct[_index]];
                    lastIndex = _index;
                    index++;
                } else {
                    isMore = true;
                    break;
                }
            }
            _index++;
        }

        rs = new Product[](index);
        for (uint i; i < index; i++) {
            rs[i] = ps[i];
        }
    }

    function ViewProduct(bytes32 _id) public view returns (Product memory rs) {
        return mIDToProduct[_id];
    }

    function CheckCallData(bytes memory callData) public override virtual returns(bool) {
        return true;
    }
}
