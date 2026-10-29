class const Product({
  required final String name,
  required final String id,
  required final double unitPrice,
});

// Repository and Repository1 are the same
// we declared the _items as a instance field by adding the final modifier
// This is a named paramter not optional so we need required modifier
class Repository<T>({required final Map<String, T> _items}) {
  void add(String key, T item) {
    _items[key] = item;
  }
}

class Repository1<T> {
  final Map<String, T> _items;
  Repository1({required this._items});
  void add(String key, T item) {
    _items[key] = item;
  }
}

// 2 and 3 are the same. Here we pass a parameter and use that to initialize the field _items
// Since we want this to be optional to take a default value, we can't modify it with required

class Repository2<T>({Map<String, T> items = const {}}) {
  final Map<String, T> _items;
  this : _items = Map.of(items);
  void add(String key, T item) {
    _items[key] = item;
  }
}

class Repository3<T> {
  final Map<String, T> _items;
  Repository3({Map<String, T> items = const {}}) : _items = Map.of(items);
  void add(String key, T item) {
    _items[key] = item;
  }
}

class ProductRepository extends Repository<Product> {
  ProductRepository.example()
    : super(
        items: {
          'p1': const Product(id: 'p1', name: 'Keyboard', unitPrice: 80),
          'p2': const Product(id: 'p2', name: 'Mouse', unitPrice: 40),
        },
      );
  Future<Product> findById(String id) async {
    // Simulate a delay of 100 milliseconds.
    // Return the matching product.
    // Throw a StateError if the ID doesn't exist.
    await Future.delayed(const Duration(milliseconds: 100));
    final product = _items[id];
    if (product == null) {
      throw StateError('id does not exist');
    }
    return product;
  }
}

class CheckoutService(final ProductRepository repository) {
  Future<double> checkout(List<String> productIds) async {
    // Load each product using the repository.
    // Calculate the total price.
    // Return the total.
    double total = 0.0;
    for (final id in productIds) {
      try {
        final product = await repository.findById(id);
        total += product.unitPrice;
      } catch (error) {
        print('error: $error');
      }
    }
    return total;
  }

  Future<double> checkout1(List<String> productIds) async {
    // Load each product using the repository.
    // Calculate the total price.
    // Return the total.
    final futures = productIds.map(repository.findById);
    double total = 0.0;
//     try {
      final result = await Future.wait(futures);
      total = result.fold(0.0, (a, c) => a + c.unitPrice);
//     } catch (error) {
//       print('error: $error');
//     }
    return total;
  }
}


Future<void> main() async {
  final repository = ProductRepository.example();
  final checkout = CheckoutService(repository);

  try {
    final total = await checkout.checkout1(['p1', 'p2']);
    print('Checkout total: \$${total.toStringAsFixed(2)}');
  } catch (error) {
    print('Checkout failed: $error');
  }
}

