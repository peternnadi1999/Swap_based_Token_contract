// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract OrderBasedSwap {
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

    constructor(){
        owner = msg.sender;
    }

    mapping (uint => Order) public orders;

    event OrderPlaced(uint256 orderId, address indexed depositor, address tokenIn, uint256 amountIn, address tokenOut, uint256 amountOut);
    event OrderFulfilled(uint256 orderId, address indexed fulfillerAdr);

    function placeOrder(address _tokenIn, uint256 _amountIn, address _tokenOut, uint256 _amountOut) external {
        if(_amountIn < 0 ){
            revert("Amounts must be greater than zero");
        }
        if( _amountOut < 0){
            revert("Amounts must be greater than zero");
        }
        
        IERC20(_tokenIn).transferFrom(msg.sender, address(this), _amountIn);
        orderCount++;
        orders[orderCount] = Order(orderCount, msg.sender, _tokenIn, _amountIn, _tokenOut, _amountOut, false
        );

        emit OrderPlaced(orderCount, msg.sender, _tokenIn, _amountIn, _tokenOut, _amountOut);
    }

    function fulfillOrder(uint256 _orderId) external {
        Order storage order = orders[_orderId];

        if (order.fulfilled){
            revert("Order already fulfilled");
        }

        if (IERC20(order.tokenOut).balanceOf(msg.sender) <= order.amountOut){
            revert("Insufficient balance to fulfill order");
        }

        IERC20(order.tokenOut).transferFrom(msg.sender, order.depositor, order.amountOut);
        IERC20(order.tokenIn).transfer(msg.sender, order.amountIn);

        order.fulfilled = true;

        emit OrderFulfilled(_orderId, msg.sender);
    }
}


