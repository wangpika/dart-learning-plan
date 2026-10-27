const double defaultTaxRate = 0.06;

class Product({required String name, required final double unitPrice}) {
  final String name;

  this : name = name.trim() {
    if (this.name.isEmpty) {
      throw ArgumentError.value(name, 'name', 'Cannot be empty');
    }

    if (!unitPrice.isFinite || unitPrice < 0) {
      throw ArgumentError.value(
        unitPrice,
        'unitPrice',
        'Must be finite and non-negative',
      );
    }
  }
}

class OrderLine({
  required final Product product,
  required final int quantity,
  required final double discountRate,
}) {
  final double subtotal;
  final double discountAmount;
  final double total;
  this
    : subtotal = product.unitPrice * quantity,
      discountAmount = product.unitPrice * quantity * discountRate,
      total = product.unitPrice * quantity * (1 - discountRate) {
    if (quantity <= 0) {
      throw ArgumentError.value(quantity, 'quantity');
    }

    if (!discountRate.isFinite || discountRate < 0 || discountRate > 1) {
      throw ArgumentError.value(discountRate, 'discountRate');
    }
  }
  factory OrderLine.fromRaw({
    required Product product,
    required int quantity,
    required double discountRate,
  }) {
    return OrderLine(
      product: product,
      quantity: quantity,
      discountRate: discountRate,
    );
  }
}

class Receipt({
  required final List<OrderLine> lines,
  required final double taxRate,
}) {
  final double subtotal;
  final double discountAmount;
  final double taxableAmount;
  final double taxAmount;
  final double total;
  this
    : subtotal = getS(lines),
      discountAmount = getDA(lines),
      taxableAmount = getS(lines) - getDA(lines),
      taxAmount = (getS(lines) - getDA(lines)) * taxRate,
      total =
          getS(lines) - getDA(lines) + (getS(lines) - getDA(lines)) * taxRate;

  static double getS(List<OrderLine> lines) =>
      lines.fold(0.0, (s, c) => s + c.subtotal);

  static double getDA(List<OrderLine> lines) =>
      lines.fold(0.0, (s, c) => s + c.discountAmount);
  void printReceipt() {
    print('subtotal: $subtotal');
    print('discountAmount: $discountAmount');
    print('taxableAmount: $taxableAmount');
    print('taxAmount: $taxAmount');
    print('total: $total');
  }
}

class Receipt1._({
  required final double subtotal,
  required final double discountAmount,
  required final double taxRate,
}) {
  final double taxableAmount;
  final double taxAmount;
  final double total;
  this
    : taxableAmount = subtotal - discountAmount,
      taxAmount = (subtotal - discountAmount) * taxRate,
      total = (subtotal - discountAmount) * (1.0 + taxRate);
  factory Receipt1({required List<OrderLine> lines, required double taxRate}) {
    final subtotal = lines.fold(0.0, (s, c) => s + c.subtotal);
    final discountAmount = lines.fold(0.0, (s, c) => s + c.discountAmount);
    return Receipt1._(
      subtotal: subtotal,
      discountAmount: discountAmount,
      taxRate: taxRate,
    );
  }
  void printReceipt() {
    print('subtotal: $subtotal');
    print('discountAmount: $discountAmount');
    print('taxableAmount: $taxableAmount');
    print('taxAmount: $taxAmount');
    print('total: $total');
  }
}

void main() {
  final product = Product(name: 'Keyboard', unitPrice: 80.00);
  final product2 = Product(name: 'Mouse', unitPrice: 40.00);

  final line = OrderLine(product: product, quantity: 2, discountRate: 0.10);
  final line2 = OrderLine(product: product2, quantity: 1, discountRate: 0);

  print('Product: ${product.name}');
  print('Subtotal: \$${line.subtotal.toStringAsFixed(2)}');
  print('Discount: \$${line.discountAmount.toStringAsFixed(2)}');
  print('Total: \$${line.total.toStringAsFixed(2)} \n');
  final receipt = Receipt1(lines: [line, line2], taxRate: defaultTaxRate);
  receipt.printReceipt();
}


