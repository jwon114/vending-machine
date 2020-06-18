# Vending Machine
Design a vending machine that behaves as follows:
- Once an item is selected and the appropriate amount of money is inserted,
the vending machine should return the correct product.
- It should also return change if too much money is provided, or ask for more
money if insufficient funds have been inserted.
- The machine should take an initial load of products and change. The change
will be of denominations 1p, 2p, 5p, 10p, 20p, 50p, £1, £2.
- There should be a way of reloading either products or change at a later point.
- The machine should keep track of the products and change that it contains.

## Extended

- What are the 3 most popular items?
- How many sales (# of items and value) have been lost due to lack of product?
- How many sales (# of items and value) have been lost due to lack of available change?
- What is the most popular item per day of week?

## Getting Started
To get started with the project:

### Prerequisites
Ruby 2.6.5 is required for the project.

### Installation
Clone or download project.

Install Gem dependencies.
```
bundle install
```

### Entry Point & Initialization
The vending machine entry point is main.rb

Initialized with the following products in inventory:
Product Name | Price | Quantity
------------ | ----- | --------
Coca Cola | 2.00 | 2
Sprite | 2.50 | 2
Fanta | 2.70 | 3
Orange Juice | 3.00 | 1
Water | 3.25 | 0

Initialized with the following coins in till:
Value | Quantity
----- | --------
2.00 | 5
1.00 | 5
0.50 | 5
0.20 | 5
0.10 | 5
0.05 | 5
0.02 | 5
0.01 | 5

To start the vending machine:
```
ruby main.rb
```

## Running the Tests
Run the tests from the project root folder.
```
rspec
```

## Implementation Details
Started with simple classes for Coins and Products. The Coin class is attributed by a single value in GBP. An instance of Product has a name and price. Till and Inventory classes hold instances of the Coin and Product respectively to represent quantities, and contain transactional logic to manage such quantities.

Calculation of the coins returned after a sale uses a greedy algorithm. The coins are ordered by value, from largest to smallest, and iterated to select the largest denomination of coin which is not greater than the remaining amount to be made. However it will not calculate the fewest number of coins. An example, if the coin denominations were 1, 3 and 4, then to make 6 this algorithm would choose (4,1,1), whereas the optimal solution is (3,3).

A Transaction class describes a single transaction that occurs in the vending machine. Transactions are in the form of a sale, no product available or no change available. All transactions are stored in memory and performance metrics are done by an Account class.

This vending machine uses the interactive command line prompt, tty-prompt, for user interaction. Display class methods interface between tty-prompt and the vending machine.

## Decisions Made
- To use classes and maintain a separation of concerns.
- Products are modelled by a Product class with name and price.
- Coins are modelled by a Coin class with value.
- Inventory manages Products quantities.
- Till manages Coin quantities and transactions with coin change.
- Transaction has a product name, value, time and type. Time is Epoch time. Type could be sale, no product available, no change available.
- Account manages Transactions and perfomance metrics.
- Display is an interface between tty-prompt and vending machine.

## Future Improvements
Future improvements if I had more time to work on this project

- Try a different algorithm to return optimal number of coins in change.
- Separation of concerns in the vending machine class.
- Redesign account details display.

## Built With
- Ruby 2.6.5
- RSpec
- tty-prompt, tty-table