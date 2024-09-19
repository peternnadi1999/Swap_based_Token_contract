# OrderBasedSwap Contract

This project implements an order-based swap contract using Solidity. The contract allows users to deposit various tokens and specify the tokens they want in return. Other users can fulfill these orders by providing the requested tokens.

## Features

- **Create Orders**: Users can create orders by depositing a specified amount of one token and requesting a specified amount of another token in return.
- **Fulfill Orders**: Other users can fulfill these orders by providing the requested tokens.
- **Events**: Emits events when orders are created and fulfilled.

## Prerequisites

- Node.js
- npm or yarn
- Hardhat
- OpenZeppelin Contracts

## Installation

1. **Clone the repository**:
    ```bash
    git clone https://github.com/yourusername/OrderBasedSwap.git
    cd OrderBasedSwap
    ```

2. **Install dependencies**:
    ```bash
    npm install
    # or
    yarn install
    ```

## Usage

1. **Compile the contract**:
    ```bash
    npx hardhat compile
    ```

2. **Run tests**:
    ```bash
    npx hardhat test
    ```

3. **Deploy the contract**:
    ```bash
    npx hardhat run scripts/deploy.js --network yourNetwork
    ```

## Contract Details

### OrderBasedSwap.sol

The `OrderBasedSwap` contract allows users to create and fulfill token swap orders.

#### Functions

- `createOrder(address _tokenIn, uint256 _amountIn, address _tokenOut, uint256 _amountOut)`: Creates a new order.
- `fulfillOrder(uint256 _orderId)`: Fulfills an existing order.

#### Events

- `OrderCreated(uint256 orderId, address indexed depositor, address tokenIn, uint256 amountIn, address tokenOut, uint256 amountOut)`: Emitted when a new order is created.
- `OrderFulfilled(uint256 orderId, address indexed fulfiller)`: Emitted when an order is fulfilled.

## License

This project is licensed under the MIT License.
