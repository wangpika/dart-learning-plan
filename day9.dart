abstract interface class Identifiable {
  String get id;
}

class const Product({
  required final String id,
  required final String name,
  required final double price,
}) implements Identifiable;

class const Customer({
  required final String id,
  required final String name,
  required final String email,
}) implements Identifiable;

abstract interface class Repository<T extends Identifiable> {
  //   final Map<String, T> _itemsMap = {};

  void save(T item);
  T? findById(String id);
  List<T> getAll();
  bool delete(String id);
}

class InMemoryRepository<T extends Identifiable> implements Repository<T> {
  final Map<String, T> _itemsMap = {};

  @override
  void save(T item) {
    _itemsMap[item.id] = item;
  }

  @override
  T? findById(String id) {
    return _itemsMap[id];
  }

  @override
  List<T> getAll() {
    return _itemsMap.values.toList();
  }

  @override
  bool delete(String id) {
    return _itemsMap.remove(id) !=null || false;
  }
}

void main() {
  // Create a Product repository.
  final Repository<Product> products =
      InMemoryRepository<Product>();

  // Create a Customer repository.
  final Repository<Customer> customers =
      InMemoryRepository<Customer>();

  // Add products.
  products.save(
    const Product(
      id: 'p1',
      name: 'MacBook',
      price: 1999,
    ),
  );

  products.save(
    const Product(
      id: 'p2',
      name: 'Keyboard',
      price: 120,
    ),
  );

  // Add customers.
  customers.save(
    const Customer(
      id: 'c1',
      name: 'Alice',
      email: 'alice@example.com',
    ),
  );

  // Verify product repository.
  assert(products.getAll().length == 2);
  assert(products.findById('p1')?.name == 'MacBook');
  assert(products.findById('missing') == null);

  // Verify customer repository.
  assert(customers.getAll().length == 1);
  assert(customers.findById('c1')?.name == 'Alice');

  // Verify update.
  products.save(
    const Product(
      id: 'p1',
      name: 'MacBook Pro',
      price: 2499,
    ),
  );

  assert(products.getAll().length == 2);
  assert(products.findById('p1')?.name == 'MacBook Pro');

  // Verify deletion.
  assert(products.delete('p2') == true);
  assert(products.delete('p2') == false);
  assert(products.getAll().length == 1);

  // Verify repositories are independent.
  assert(customers.getAll().length == 1);

  print('All repository tests passed!');
}

