// Consuming existing Streams
Stream<List<ConnectivityResult>> get onConnectivityChanged;
final subscription = Connectivity()
    .onConnectivityChanged
    .listen((results) {
      print('Connectivity changed: $results');
    });

// Creating Streams with async*
Stream<Order> monitorOrder(String orderId) async* {
  while (true) {
    final order = await fetchOrder(orderId);

    yield order;

    if (order.isCompleted) {
      break;
    }

    await Future.delayed(const Duration(seconds: 5));
  }  
}
/*
When implementing a production Flutter feature, ask yourself:
Question	Recommended approach
Does an SDK already provide a Stream?	Use it directly
Do I need to generate events sequentially?	async*
Does my event source use callbacks?	StreamController
Do I need to transform an existing Stream?	Stream operators
Do I need to combine multiple Streams?	Stream combinators
Do I need to consume events with explicit lifecycle control?	listen()

One more important distinction: a Stream isn't necessarily a state container.

For example, if a new widget subscribes to a broadcast playback-position Stream, it won't automatically receive the latest playback position.

If your application needs current state as well as future updates, you may need a ValueNotifier, a state-holding ViewModel, or another state-management mechanism alongside the Stream.
*/

import 'dart:async';

enum OrderStatus {
  created,
  preparing,
  readyForPickup,
  outForDelivery,
  delivered,
  cancelled,
}

class OrderUpdate {
  final String orderId;
  final OrderStatus status;
  final DateTime timestamp;

  const OrderUpdate({
    required this.orderId,
    required this.status,
    required this.timestamp,
  });

  @override
  String toString() {
    return '$orderId: ${status.name} at $timestamp';
  }
}

class OrderTrackingService {
  final StreamController<OrderUpdate> _controller =
      StreamController<OrderUpdate>.broadcast();

  Stream<OrderUpdate> get updates => _controller.stream;

  // Implement updateStatus().
  // It should create an OrderUpdate and emit it.
  void updateStatus(OrderUpdate orderUpdate) {
    _controller.add(orderUpdate);
  }

  // Implement close().
  // Close the StreamController.
  void close() {
    _controller.close();
  }

  Stream<OrderUpdate> simulateOrderTracking(String orderId) async* {
    final statuses = [
      OrderStatus.created,
      OrderStatus.preparing,
      OrderStatus.readyForPickup,
      OrderStatus.outForDelivery,
      OrderStatus.delivered,
    ];

    // Iterate over statuses.
    // Wait 1 second between updates.
    // Emit each OrderUpdate using yield.
    for (final status in statuses) {
      await Future.delayed(const Duration(seconds: 1));
      yield OrderUpdate(
        orderId: orderId,
        status: status,
        timestamp: DateTime.now(),
      );
    }
  }

  Future<void> trackOrder(String orderId) async {
    // Use await for to consume the stream.
    // Print every order update.
    // Handle any errors appropriately.
    Stream<OrderUpdate> stream = simulateOrderTracking('order 1');
    await for (final item in stream) {
      print('update: ${item.status}');
    }
  }
}

void main() {
  final service = OrderTrackingService();
  service.trackOrder('ORD-001');
}

