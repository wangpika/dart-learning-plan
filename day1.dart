const double defaultTaxRate = 0.06;

class Receipt({
  required final String productName,
  required final double unitPrice,
  required final int quantity,
  final double discountRate = 0.0,
}) {
  final double subtotal;
  final double discountAmount;
  final double taxableAmount;
  final double taxAmount;
  final double total;

  this : subtotal = unitPrice * quantity,
         discountAmount = unitPrice * quantity * discountRate,
         taxableAmount =
             unitPrice * quantity * (1 - discountRate),
         taxAmount =
             unitPrice * quantity * (1 - discountRate) * defaultTaxRate,
         total =
             unitPrice * quantity * (1 - discountRate) *
                 (1 + defaultTaxRate);

  void printReceipt() {
    print('Product: $productName');
    print('Subtotal: \$${subtotal.toStringAsFixed(2)}');
    print('Discount: \$${discountAmount.toStringAsFixed(2)}');
    print('Tax: \$${taxAmount.toStringAsFixed(2)}');
    print('Total: \$${total.toStringAsFixed(2)}');
  }
}

void main() {
  final receipt = Receipt(
    productName: 'Mechanical Keyboard',
    unitPrice: 89.99,
    quantity: 2,
    discountRate: 0.1,
  );

  receipt.printReceipt();
}
