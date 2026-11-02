/*
4. Extension methods are statically resolved
This is one of the most important concepts.

Unlike virtual instance methods, extension methods are selected based on the static type of the expression, not the runtime type.
Feature	Method resolution
Ordinary instance method	Runtime type
Extension method	Static type
Extension getter	Static type
Extension operator	Static type
*/
class Animal {}

class Dog extends Animal {}

extension AnimalExtension on Animal {
  void speak() {
    print('Animal speaks');
  }
}

extension DogExtension on Dog {
  void speak() {
    print('Dog barks');
  }
}

void main() {
  Animal animal = Dog();

  animal.speak();
}

/*
The key syntax:
extension type UserId(String value)


Here:
- UserId is the new static type.
- String is the representation type.
- value is the representation instance variable.

Feature	Extension method	Extension type	Typedef	Wrapper class
Adds methods to existing type	Yes	Yes	No	Yes
Creates distinct static type	No	Yes	No	Yes
New runtime object	No	No	No	Yes
Prevents mixing domain IDs	No	Yes	No	Yes
Creates a type alias	No	No	Yes	No
*/

extension A on String {
  String get normalized => this.trim();
  String normalize() => this.trim();
  bool isSame(String value) => this == value;
}

extension type UserId(String value);
extension type UserName(String value) {
  String get normalized => value.trim();
  String normalize() => value.trim();
  bool isSame(String newValue) => value == newValue;
}

typedef Mapper<T,R> = R Function(T);

R transform<T,R>(T value, Mapper<T,R> mapper) => mapper(value);

void main() {
  final a = '123 '.normalized;
  print('a: $a');
  final b = '456 '.normalize();
  print('b: $b');
  final c = '123'.isSame('123 '.normalized);
  print('c: $c');
  
  final name = UserName(' abc ');
  print('${name.normalized}');
  print('${name.normalize()}');
  print('${name.isSame(' abc')}');

  final result = transform('1', (s) => int.parse(s));
  final result1 = transform<String, int>('1', (s) => int.parse(s));
  print(result);
  print(result1);
}

