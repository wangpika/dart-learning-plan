enum MediaType { movie, liveChannel, episode }

enum SubscriptionTier { free, standard, premium }

enum PlaybackStatus {
  idle,
  loading,
  playing,
  paused,
  buffering,
  completed,
  error,
}

extension type const MediaId(int value) {
  MediaId.parse(String raw) : value = int.parse(raw);
}

abstract class const MediaItem({
  required final MediaId id,
  required final String title,
  required final MediaType type,
  final Duration? duration,
  required final SubscriptionTier requiredTier,
}) {
  // TODO: Abstract method describing media
  String describe();
}

class const Movie({
  required super.id,
  required super.title,
  required final Duration duration,
  required super.requiredTier,
}) extends MediaItem {
  this : super(type: .movie, duration: duration);
  @override
  String describe() {
    return 'Movie: title: $title, type: $type, duration: $duration, requiredTier: $requiredTier';
  }
}

class const LiveChannel({
  required super.id,
  required super.title,
  required super.requiredTier,
}) extends MediaItem {
  this : super(type: .liveChannel);
  @override
  String describe() {
    return 'LiveChannel: title: $title, type: $type, requiredTier: $requiredTier';
  }
}

typedef PricingConfig = ({
  double basePrice,
  double taxRate,
  double discountRate,
});

double calculatePrice(PricingConfig config) {
  return config.basePrice * (1 - config.discountRate) * (1 + config.taxRate);
}

sealed class PurchaseResult<T> {
  const PurchaseResult();
}

class PurchaseSuccess<T> extends PurchaseResult<T> {
  final T value;
  PurchaseSuccess(this.value);
}

class PurchaseFailure<T> extends PurchaseResult<T> {
  final String reason;
  PurchaseFailure(this.reason);
}

PurchaseResult<double> purchaseMedia({
  required MediaItem media,
  required SubscriptionTier userTier,
  required PricingConfig pricing,
}) {
  if (Enum.compareByIndex(userTier, media.requiredTier) < 0) {
    return PurchaseFailure('Insufficient subscription tier');
  }
  final price = calculatePrice(pricing);
  if (price < 0) {
    return PurchaseFailure('Invalid price');
  }
  return PurchaseSuccess(price);
}

String describePurchase(PurchaseResult<double> result) => switch (result) {
  PurchaseSuccess(:final value) => 'Purchase successful: \$${value}',
  PurchaseFailure(:final reason) => 'Purchase failed: $reason',
};

// 3

abstract interface class Repository<T, ID> {
  Future<T?> getById(ID id);
  Future<List<T>> getAll();
  Future<void> save(T item);
}

typedef IdExtractor<T, ID> = ID Function(T item);

class InMemoryRepository<T, ID> implements Repository<T, ID> {
  final Map<ID, T> _itemsMap = {};
  final IdExtractor<T, ID> idOf;
  InMemoryRepository({required this.idOf});
  Future<T?> getById(ID id) async {
    return _itemsMap[id];
  }

  Future<List<T>> getAll() async {
    return _itemsMap.values.toList();
  }

  Future<void> save(T item) async {
    _itemsMap[idOf(item)] = item;
  }
}

abstract interface class Identifiable<ID> {
  ID get id;
}

List<MediaItem> premiumContent(List<MediaItem> items) {
  return items.where((item) => item.requiredTier == .premium).toList();
}

Map<MediaType, List<MediaItem>> groupByType(List<MediaItem> items) {
  final Map<MediaType, List<MediaItem>> map = {};
  for (final item in items) {
    map.update(item.type, (value) => [...value, item], ifAbsent: () => [item]);
  }
  return map;
}

Duration totalMovieDuration(List<Movie> movies) {
  return movies.fold(
    Duration.zero,
    (a, c) => a + (c.duration),
  );
}

Future<void> main() async{
  final movie = Movie(
    id: const MediaId(1),
    title: 'Interstellar',
    duration: const Duration(hours: 2, minutes: 49),
    requiredTier: SubscriptionTier.premium,
  );

  final channel = LiveChannel(
    id: const MediaId(2),
    title: 'News Channel',
    requiredTier: SubscriptionTier.standard,
  );

  // Verify identifiers
  assert(movie.id == const MediaId(1));
  assert(channel.id != movie.id);

  // Verify media types
  assert(movie.type == MediaType.movie);
  assert(channel.type == MediaType.liveChannel);

  // Verify duration modeling
  assert(movie.duration == const Duration(hours: 2, minutes: 49));
  assert(channel.duration == null);

  // Verify subscription tiers
  assert(movie.requiredTier == SubscriptionTier.premium);
  assert(channel.requiredTier == SubscriptionTier.standard);

  // Verify polymorphism
   List<MediaItem> media = [movie, channel];

  assert(media.length == 2);
  assert(media.first.describe().isNotEmpty);

  print('PASS: Media domain modeling');
  print('PASS: Type safety and identifiers');
  print('PASS: Polymorphism');
  print('ALL EXERCISE 1 TESTS PASSED!');

  // 2. Pricing and sealed classes
  const pricing = (basePrice: 10.0, taxRate: 0.06, discountRate: 0.10);

  final purchase = purchaseMedia(
    media: movie,
    userTier: SubscriptionTier.premium,
    pricing: pricing,
  );

  assert(purchase is PurchaseSuccess<double>);

  final purchaseMessage = describePurchase(purchase);

  print(purchaseMessage);

  final rejectedPurchase = purchaseMedia(
    media: movie,
    userTier: SubscriptionTier.free,
    pricing: pricing,
  );

  assert(rejectedPurchase is PurchaseFailure<double>);

  print('PASS: Pricing and pattern matching');
  
  // 3. Generics and repositories
  final repository = InMemoryRepository<MediaItem, MediaId>(
    idOf: (item) => item.id,
  );

  await repository.save(movie);
  await repository.save(channel);

  final retrieved = await repository.getById(const MediaId(1));

  assert(retrieved?.title == 'Interstellar');
  assert((await repository.getAll()).length == 2);

  print('PASS: Generic repository');

  // 4. Collection operations
   media = await repository.getAll();

  assert(media.length == 2);
  assert(premiumContent(media).length == 1);

  final grouped = groupByType(media);

  assert(grouped[MediaType.movie]?.length == 1);
  assert(grouped[MediaType.liveChannel]?.length == 1);

  print('PASS: Collection operations');
}

