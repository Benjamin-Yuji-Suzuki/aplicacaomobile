import 'package:flutter/services.dart';

class CompassService {
  static const MethodChannel _channel = MethodChannel('com.example.cirio/compass');

  static Future<bool> isAvailable() async {
    try {
      final result = await _channel.invokeMethod<bool>('isAvailable');
      return result ?? false;
    } catch (e) {
      return false;
    }
  }

  static Stream<double>? _compassStream;

  static Stream<double> get events {
    _compassStream ??= _createCompassStream();
    return _compassStream!;
  }

  static Stream<double> _createCompassStream() {
    const eventChannel = EventChannel('com.example.cirio/compass_events');
    return eventChannel.receiveBroadcastStream().map((event) {
      if (event is double) return event;
      if (event is num) return event.toDouble();
      return 0.0;
    });
  }
}
