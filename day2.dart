const NULL_PRICE = 'Price unavailable';
const NULL_STOCK = 'Stock unknown';
const NULL_DESCRIPTION = 'No description';
const NULL_INVENTORY_VALUE = 'Cannot calculate inventory value';

class Product({
  required final String name,
  final double? price,
  final int? stock,
  final String? description,
}) {
  String get formattedPrice {
    // If price is null, return 'Price unavailable'.
    // Otherwise return a string with exactly 2 decimal places.
    return price?.toStringAsFixed(2) ?? NULL_PRICE;
  }

  String get formattedStock {
    // Return the stock as a string, or 'Stock unknown'.
    // Remember: stock = 0 is a valid, known value.
    return stock?.toString() ?? NULL_STOCK;
  }

  String get formattedDescription {
    // Trim the description.
    // Return 'No description' if it is null or blank.
    final value = description?.trim() ?? NULL_DESCRIPTION;
    return value == '' ? NULL_DESCRIPTION : value;
  }

  double? get inventoryValue {
    // Return null if either price or stock is unknown.
    // Otherwise return price * stock.
    final priceLocal = price;
    final stockLocal = stock;
    if (priceLocal != null && stockLocal != null) {
      return priceLocal * stockLocal;
    }
    return null;
  }

  String get formattedInventoryValue {
    // Return a formatted inventory value when available.
    // Otherwise return 'Cannot calculate inventory value'.
    final value = inventoryValue;
    if (value != null) {
      return '\$${value.toStringAsFixed(2)}';
    }
    return NULL_INVENTORY_VALUE;
  }

  void printSummary() {
    print('Product: $name');
    print('Price:  $formattedPrice');
    print('Stock:  $formattedStock');
    print('Description:   $formattedDescription');
    print('Inventory value:  $formattedInventoryValue');
  }
}

void main() {
  final products = <Product>[
    Product(
      name: 'Keyboard',
      price: 79.99,
      stock: 10,
      description: ' Mechanical keyboard ',
    ),
    Product(
      name: 'Mouse',
      price: 29.50,
      stock: 0,
      description: 'Wireless mouse',
    ),
    Product(name: 'Monitor', price: 249.99, description: '  '),
    Product(name: 'USB cable', stock: 25),
  ];

  for (final product in products) {
    product.printSummary();
    print('---');
  }
}

