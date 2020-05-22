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
Requirements to run the project.
- Ruby 2.6.5

### Installation
Clone or download project.

Install Gem dependencies.
```
bundle install
```

### Entry Point
Entry point is vending_machine.rb file. Tests contain example input data when initialising vending machine.

Vending machine initialisation
```
# Products input with price in £.
products = {
  '01' => {
    :name => 'Coca Cola',
    :price => 1.60,
    :quantity => 2
  },
  '02' => {
    :name => 'Sprite',
    :price => 1.50,
    :quantity => 2
  },
  '03' => {
    :name => 'Fanta',
    :price => 1.45,
    :quantity => 2
  },
  '04' => {
    :name => 'Orange Juice',
    :price => 2.00,
    :quantity => 0
  },
  '05' => {
    :name => 'Water',
    :price => 2.23,
    :quantity => 1
  }
}

# Coins input to vending machine, where the keys are coin types, 2.00 is £2 and 0.01 is £0.01, and values are coin quantities.
coins = {
  0.01 => 0,
  0.02 => 4,
  0.05 => 5,
  0.10 => 6,
  0.20 => 2,
  0.50 => 4,
  1.00 => 7,
  2.00 => 8
}

vending_machine = VendingMachine.new(products: products, coins: coins)
product, change = vending_machine.vend(code: '01', paid: 3.20)
```

## Running the Tests
Run the tests from the project root folder.
```
rspec
```

## Implementation Details
Started with a main vending machine class to encapsulate all functionalities. Creating a new instance of vending machine initialises the product inventory and till for dispensing change. Class attributes inventory and till are class instances of Inventory and Till respectively. Vending machine manages the inventory and till interaction, and can be reloaded with new values. Classes such as Inventory and Till create a separation of concerns, and enable the vending machine to focus on the exchange of money and product.

Inventory class manages product queries such as name, quantity and price. When a product is dispensed, product quantites are also managed here.

Any transactions of change is handled by the Till class. This class manages the coins used for change held by the vending machine. When an action to request change is fired, a breakdown of the coins and quantities is performed. This build a hash of which coins and how many are required to satisfy the change amount, with an attempt to use the fewest number of coins possible. Insufficient till funds could be raised when there are not enough coins to equal the change returned. When the correct change is calculated, the breakdown hash is merged with its current coin collection to complete the transaction.

Error exceptions were raised handle situations such as insufficient funds inserted, incorrect code selection, product availablity and so forth.

## Decisions Made
- To use classes and maintain a separation of concerns.
- Products data as a hash with selection code as a key and product details as values.
- Coins data hash to track which coins and how many are in the vending machine till.
- Products class to manage vending machine products.
- Till class to manage vending machine till.

## Future Improvements
Future improvements if I had more time to work on this project

- Refactor or improve the coins in change calculation.
- Return a breakdown of change when dispensing.
- Separate some of the calculation logic from the vending machine class.
- User interface to interact with the project.

## Built With
- Ruby 2.6.5
- RSpec