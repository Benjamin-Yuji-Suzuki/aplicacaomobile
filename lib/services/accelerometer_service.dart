import 'package:flutter/services.dart';

class AccelerometerService {
  static const MethodChannel _channel = MethodChannel('com.example.cirio/accelerometer');

  static Future<bool> isAvailable() async {
    try {
      final result = await _channel.invokeMethod<bool>('isAvailable');
      return result ?? false;
    } catch (e) {
      return false;
    }
  }

  static Stream<double>? _accelerometerStream;

  static Stream<double> get events {
    _accelerometerStream ??= _createAccelerometerStream();
    return _accelerometerStream!;
  }

  static Stream<double> _createAccelerometerStream() {
    const eventChannel = EventChannel('com.example.cirio/accelerometer_events');
    return eventChannel.receiveBroadcastStream().map((event) {
      if (event is double) return event;
      if (event is num) return event.toDouble();
      return 0.0;
    });
  }
}
