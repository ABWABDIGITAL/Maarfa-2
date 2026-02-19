import 'dart:async';

class NotificationEvent {
  final String type;
  final String objectId;

  const NotificationEvent({required this.type, required this.objectId});
}

class NotificationEventBus {
  NotificationEventBus._();
  static final NotificationEventBus _instance = NotificationEventBus._();
  static NotificationEventBus get instance => _instance;

  final _controller = StreamController<NotificationEvent>.broadcast();

  Stream<NotificationEvent> get stream => _controller.stream;

  void fire(NotificationEvent event) {
    _controller.add(event);
  }

  void dispose() {
    _controller.close();
  }
}
