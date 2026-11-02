import 'dart:async';

extension StringExtensions on String {
  // Create a getter called normalizedEmail.
  // It should trim whitespace and convert to lowercase.
  String get normalizedEmail => this.trim().toLowerCase();

  // Create a getter called isValidEmail.
  // For this exercise, check whether the string:
  // - contains exactly one @
  // - contains a dot after the @
  bool get isValidEmail {
    final regex = RegExp(r'^[^@]*@[^@]*\.[^@]*$');
    return regex.hasMatch(this);
  }
}

extension type UserId(String value) {
  // Add a named constructor UserId.parse(String raw).
  // Trim whitespace before storing the value.
  UserId.parse(String raw) : value = raw.trim();

  // Add a getter isValid.
  // A valid ID must start with 'user-'.
  bool get isValid => value.startsWith('user-');
}

extension type Email(String value) {
  // Add a named constructor Email.parse(String raw).
  // Normalize the email before storing it.
  Email.parse(String raw) : value = raw.normalizedEmail;

  // Add a getter isValid.
  bool get isValid => value.isValidEmail;
}

typedef UserCreatedCallback = void Function(User);
typedef UserMap = Map<UserId, User>;

class User({
  required final UserId id,
  required final Email email,
  required final String name,
}) {
  @override
  String toString() {
    return 'User(id: ${id.value}, '
        'email: ${email.value}, name: $name)';
  }
}

class UserRepository {
  final UserMap _users = {};

  final UserCreatedCallback? onUserCreated;

  UserRepository({this.onUserCreated});

  void add(User user) {
    // 1. Validate user.id and user.email.
    // 2. Throw ArgumentError if either is invalid.
    // 3. Prevent duplicate IDs.
    // 4. Store the user.
    // 5. Invoke onUserCreated if provided.
    if(!user.id.isValid) {
      throw ArgumentError.value(user.id, 'id', 'invalid');
    }
    if(!user.email.isValid) {
      throw ArgumentError.value(user.email, 'email', 'invalid');
    }
    if(_users.containsKey(user.id)) {
      throw ArgumentError.value(user.id, 'id', 'User id existed');
    }
    _users[user.id] = user;
    onUserCreated?.call(user);
  }

  User? findById(UserId id) {
    // Return the matching user.
    return _users[id];
  }

  int get length => _users.length;
}

void main() {
  var callbackCount = 0;

  final repository = UserRepository(
    onUserCreated: (user) {
      callbackCount++;
      print('Created: ${user.name}');
    },
  );

  final user1 = User(
    id: UserId.parse(' user-001 '),
    email: Email.parse(' ALICE@EXAMPLE.COM '),
    name: 'Alice',
  );

  final user2 = User(
    id: UserId.parse('user-002'),
    email: Email.parse('bob@example.com'),
    name: 'Bob',
  );

  repository.add(user1);
  repository.add(user2);

  // Verify extension type behavior.
  assert(user1.id.value == 'user-001');
  assert(user1.email.value == 'alice@example.com');

  // Verify repository.
  assert(repository.length == 2);
  assert(repository.findById(user1.id) == user1);
  assert(repository.findById(UserId.parse('user-999')) == null);

  // Verify callback.
  assert(callbackCount == 2);

  // Verify extension methods.
  assert(' ALICE@EXAMPLE.COM '.normalizedEmail ==
      'alice@example.com');

  assert('alice@example.com'.isValidEmail);
  assert(!'invalid-email'.isValidEmail);

  // Verify invalid ID.
  var invalidIdRejected = false;

  try {
    repository.add(
      User(
        id: UserId.parse('invalid-001'),
        email: Email.parse('test@example.com'),
        name: 'Invalid',
      ),
    );
  } on ArgumentError {
    invalidIdRejected = true;
  }

  assert(invalidIdRejected);
  assert(repository.length == 2);

  // Verify duplicate ID.
  var duplicateRejected = false;

  try {
    repository.add(
      User(
        id: UserId.parse('user-001'),
        email: Email.parse('another@example.com'),
        name: 'Duplicate',
      ),
    );
  } on ArgumentError {
    duplicateRejected = true;
  }

  assert(duplicateRejected);
  assert(repository.length == 2);

  print('All Day 10 tests passed!');
}
