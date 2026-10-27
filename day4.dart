sealed class Base({required final double size}) {}

class A({
  required final int amount,
  required final String title,
  required super.size,
}) extends Base {}

class B({
  required final bool valid,
  required final String reason,
  required super.size,
}) extends Base {}

String getSize(Base base) => switch (base) {
  A(amount: > 5, :final size, :final title) => 'title: $title size: ${size * 10}',
  A(amount: < 0, :final size,:final title) => 'title: $title size: ${size * 1}',
  A(:final size,:final title) =>'title: $title size: ${size * 5}',
  B(valid: true, :final size,:final reason) => 'reason: $reason size: ${size * 10}',
  B(:final size,:final reason) => 'reason: $reason size: ${size * 5}',
};

void main() {
  final a1 = A(amount: -1, title: 't1', size: 2);
  final a2 = A(amount: 1, title: 't2', size: 2);
  final a3 = A(amount: 9, title: 't3', size: 2);
  final b1 = B(valid: true, reason: 't4', size: 2);
  final b2 = B(valid: false, reason: 't5', size: 2);
  for(final item in [a1,a2,a3,b1,b2]) {
    print(getSize(item));
  }
}

enum CustomerTier { standard, silver, gold }

enum OrderCategory { small, medium, large }

sealed class PricingResult {}

class PricingSuccess extends PricingResult {
  final double subtotal;
  final double discount;
  final double total;

  PricingSuccess({
    required this.subtotal,
    required this.discount,
    required this.total,
  });
}

class PricingFailure extends PricingResult {
  final String message;

  PricingFailure(this.message);
}

class OrderPricing {
  static double discountForQuantity(int quantity) => switch (quantity) {
    <= 0 => 0,
    <= 2 => 0.05,
    <= 5 => 0.10,
    _ => 0.15,
  };

  static OrderCategory categoryForQuantity(int quantity) => switch (quantity) {
    <= 5 => .small,
    <= 20 => .medium,
    _ => .large,
  };

  static ({bool eligible, String reason}) checkEligibility({
    required double subtotal,
    required CustomerTier tier,
  })
  //     => switch (tier) {
  //     .standard when subtotal >= 50 => (eligible: true, reason: 'valid'),
  //     .silver when subtotal >= 40 => (eligible: true, reason: 'valid'),
  //     .gold when subtotal >= 25 => (eligible: true, reason: 'valid'),
  //     _ => (eligible: false, reason: 'invalid'),
  //   };
  => switch ((tier, subtotal)) {
    (.standard, >= 50) => (eligible: true, reason: 'valid'),
    (.silver, >= 40) => (eligible: true, reason: 'valid'),
    (.gold, >= 25) => (eligible: true, reason: 'valid'),
    _ => (eligible: false, reason: 'invalid'),
  };

  static PricingResult priceOrder({
    required double unitPrice,
    required int quantity,
    required CustomerTier tier,
  }) {
    // 1. Reject negative unit prices and quantities <= 0.
    // 2. Calculate subtotal.
    // 3. Calculate discount using discountForQuantity.
    // 4. Calculate total = subtotal - discount.
    // 5. Return PricingSuccess or PricingFailure.
    if (unitPrice < 0) return PricingFailure('negative price');
    if (quantity <= 0) return PricingFailure('invalid quantity');
    final category = categoryForQuantity(quantity);
    final subtotal = unitPrice * quantity;
    final discount = discountForQuantity(quantity) * subtotal;
    final total = subtotal - discount;
    return PricingSuccess(
      subtotal: subtotal,
      discount: discountForQuantity(quantity),
      total: total,
    );
  }

  static String describeResult(PricingResult result)
  // Use an exhaustive switch expression and object patterns.
  // Success: include subtotal, discount and total.
  // Failure: include the message.
  => switch (result) {
    PricingFailure(:final message) => 'failed to price $message',
    PricingSuccess(:final subtotal, :final discount, :final total) =>
      'Subtotal: \$$subtotal \nQuantity Discount: ${discount * 100}% \nDiscount: ${subtotal * discount} \nTotal: \$$total',
  };
}

void main() {
  final result = OrderPricing.priceOrder(
    unitPrice: 20,
    quantity: 4,
    tier: CustomerTier.gold,
  );

  print(OrderPricing.describeResult(result));

  final eligibility = OrderPricing.checkEligibility(
    subtotal: 80,
    tier: CustomerTier.silver,
  );

  print(eligibility.eligible);
  print(eligibility.reason);
}

