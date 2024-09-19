// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";


contract OrderBasedSwap is ReentrancyGuard {

    address owner;
    uint orderCount;


    struct Order {
        uint id;
        address depositor;
        address tokenIn;
        uint256 amountIn;
        address tokenOut;
        uint256 amountOut;
        bool fulfilled;
    }

    mapping (uint => Order) public orders;

    constructor(){
        owner = msg.sender;
    }

    error YouCannotPlaceOrder();
    error AmountsMustBeGreaterThanZero();
    error AddressZeroDetected();


    event OrderPlaced(uint256 orderId, address indexed depositor, address tokenIn, uint256 amountIn, address tokenOut, uint256 amountOut);
    event OrderFulfilled(uint256 orderId, address indexed fulfillerAdr);
    event OrderCancelled(uint orderId, address indexed depositor);

    function placeOrder(address _tokenIn, uint256 _amountIn, address _tokenOut, uint256 _amountOut) external nonReentrant {
        if(msg.sender == address(this)){
            revert YouCannotPlaceOrder();
        }

        if(_tokenIn == address(0)){
            revert AddressZeroDetected();
        }

        if(_amountIn < 0 ){
            revert AmountsMustBeGreaterThanZero();
        }
        if( _amountOut < 0){
             revert AmountsMustBeGreaterThanZero();
        }
        
        IERC20(_tokenIn).transferFrom(msg.sender, address(this), _amountIn);
        orderCount++;
        orders[orderCount] = Order(orderCount, msg.sender, _tokenIn, _amountIn, _tokenOut, _amountOut, false
        );

        emit OrderPlaced(orderCount, msg.sender, _tokenIn, _amountIn, _tokenOut, _amountOut);
    }

    function fulfillOrder(uint256 _orderId) external nonReentrant {
        Order storage order = orders[_orderId];

        if (order.fulfilled){
            revert OrderAlreadyFulfilled();
        }

        if (IERC20(order.tokenOut).balanceOf(msg.sender) <= order.amountOut){
            revert("Insufficient balance to fulfill order");
        }


        order.fulfilled = true;

        IERC20(order.tokenOut).transferFrom(msg.sender, order.depositor, order.amountOut);
        IERC20(order.tokenIn).transfer(msg.sender, order.amountIn);

        emit OrderFulfilled(_orderId, msg.sender);
    }

     function cancelOrder(uint256 _orderId) external nonReentrant {
        Order storage order = orders[_orderId];
        if (order.fulfilled){
            revert("Order already fulfilled");
        }
        if(order.depositor == msg.sender){
            revert( "Only the depositor can cancel the order");
        }

        order.fulfilled = false;

        IERC20(order.depositToken).transfer(order.depositor, order.depositAmount);

        emit OrderCancelled(_orderId, msg.sender);
    }
}


