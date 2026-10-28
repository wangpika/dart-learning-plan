import 'package:collection/collection.dart';

abstract class PaymentProcessor {
  final String provider;

  PaymentProcessor(this.provider);

  void pay(double amount);

  void logPayment(double amount) {
    print('$provider processed \$$amount');
  }
}

class StripeProcessor(super.provider) extends PaymentProcessor {
  @override
  void pay(double amount) {
    print('pay amount $amount');
  }
}

class PayPalProcessor implements PaymentProcessor {
  @override
  String get provider => 'paypal';

  @override
  void pay(double amount) {
    print('pay amount $amount');
  }

  @override
  void logPayment(double amount) {
    print('$provider processed \$$amount');
  }
}

class VenmoProcessor(final String provider) implements PaymentProcessor {
  @override
  void pay(double amount) {
    print('pay amount $amount');
  }

  @override
  void logPayment(double amount) {
    print('$provider processed \$$amount');
  }
}

abstract class Product({
  required final String id,
  required final String name,
  required final double price,
}) implements Identifiable{
  String get category;

  double get finalPrice => price;
}

class PhysicalProduct({
  required super.id,
  required super.name,
  required super.price,
  required final double shippingFee,
}) extends Product {
  @override
  String get category => 'Physical';

  @override
  double get finalPrice => price + shippingFee;
}

class DigitalProduct({
  required super.id,
  required super.name,
  required super.price,
}) extends Product {
  @override
  String get category => 'Digital';
}

abstract interface class DiscountPolicy {
  double calculateDiscount(double subtotal);
}

class PercentageDiscount(final double rate) implements DiscountPolicy {
  @override
  double calculateDiscount(double subtotal) {
    return subtotal * rate;
  }
}

mixin Loggable {
  void log(String message) {
    print('[LOG]: $message');
  }
}

abstract interface class Identifiable {
  String get id;
}

class ProductRepository<T extends Identifiable> with Loggable {
  final List<T> _items = [];
  void add(T item) {
    _items.add(item);
  }

  T? findById(String id) {
    return _items.firstWhereOrNull((item) => item.id == id);
  }
}

sealed class CheckoutResult {}

class CheckoutSuccess(final double total) extends CheckoutResult;
class CheckoutFailure(final String message) extends CheckoutResult;

String describeCheckout(CheckoutResult result) => switch (result) {
  CheckoutSuccess(:final total) => 'paid ${total.toStringAsFixed(2)}',
  CheckoutFailure(:final message) => 'failed with $message',
};

void main() {
  final repository = ProductRepository<Product>();

  repository.add(
    PhysicalProduct(id: 'p1', name: 'Keyboard', price: 80, shippingFee: 7),
  );

  repository.add(DigitalProduct(id: 'p2', name: 'Dart Course', price: 50));

  print(repository.findById('p1')?.finalPrice);
  print(repository.findById('p2')?.finalPrice);

  final policy = PercentageDiscount(0.10);
  print(policy.calculateDiscount(100));

  print(describeCheckout(CheckoutSuccess(87)));
  print(describeCheckout(CheckoutFailure('Invalid product')));
}

