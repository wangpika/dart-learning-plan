// way to create map from list
void main() {
  List<String> fruits = ['apple', 'banana', 'cherry'];

  // Key is the fruit name, value is its length
  var fruitMap = { for (var item in fruits) item : item.length };

  print(fruitMap); // {apple: 5, banana: 6, cherry: 6}
}
import 'package:collection/collection.dart';

class const Product({
  required final String id,
  required final String name,
  required final double unitPrice,
  required final int stock,
}) {}

class const OrderItem({
  required final String productId,
  required final int quantity,
}) {}

class OrderProcessor {
  final List<Product> products;
  final Map<String, Product> productIdMap;
  new(List<Product> originalItems)
    : products = List<Product>.unmodifiable(originalItems),
      productIdMap = Map<String, Product>.unmodifiable({
        for (final product in originalItems) product.id: product,
      });
  // Return the product with the matching ID.
  // Return null when no product matches.
  Product? findProductById(String id) {
    //     return products.firstWhereOrNull((product) => product.id == id);
    return productIdMap[id];
  }

  // Return a list containing only products with stock > 0.
  List<Product> availableProducts() {
    return products.where((product) => product.stock > 0).toList();
  }

  // Calculate the total cost of the order.
  // Ignore order items whose product ID does not exist.
  double calculateTotal(List<OrderItem> items) {
    //     var total = 0.0;
    //     for (var item in items) {
    //       final product = findProductById(item.productId);
    //       if (product == null) continue;
    //       total += product.unitPrice * item.quantity;
    //     }

    //     return total;
    return items
        .map((item) {
          final product = findProductById(item.productId);
          if (product == null) return 0.0;
          return product.unitPrice * item.quantity;
        })
        .fold<double>(0.0, (t, a) => t + a);
  }

  // Return a map of product ID -> total quantity ordered.
  // Combine quantities for duplicate product IDs.
  Map<String, int> summarizeQuantities(List<OrderItem> items) {
    final result = <String, int>{};
    for (final item in items) {
      final productId = item.productId;
      result.update(
        productId,
        (value) => value + item.quantity,
        ifAbsent: () => item.quantity,
      );
    }
    return result;
  }
}

void main() {
  final processor = OrderProcessor([
    const Product(id: 'p1', name: 'Keyboard', unitPrice: 50.0, stock: 10),
    const Product(id: 'p2', name: 'Mouse', unitPrice: 25.0, stock: 0),
    const Product(id: 'p3', name: 'Monitor', unitPrice: 200.0, stock: 5),
  ]);

  final order = [
    const OrderItem(productId: 'p1', quantity: 2),
    const OrderItem(productId: 'p2', quantity: 1),
    const OrderItem(productId: 'p1', quantity: 3),
    const OrderItem(productId: 'missing', quantity: 4),
  ];

  print('Keyboard found: ${processor.findProductById('p1')?.name}');

  print('Missing product: ${processor.findProductById('missing')}');

  print(
    'Available: ${processor.availableProducts().map((p) => p.name).join(', ')}',
  );

  print('Total: \$${processor.calculateTotal(order).toStringAsFixed(2)}');

  print('Quantities: ${processor.summarizeQuantities(order)}');
}

