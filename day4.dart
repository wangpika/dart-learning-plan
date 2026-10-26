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

