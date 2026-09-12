import 'package:flutter/services.dart';

class LightSensorService {
  static const MethodChannel _channel = MethodChannel('com.example.cirio/light');

  static Future<bool> isAvailable() async {
    try {
      final result = await _channel.invokeMethod<bool>('isAvailable');
      return result ?? false;
    } catch (e) {
      return false;
    }
  }

  static Stream<double>? _lightStream;

  static Stream<double> get events {
    _lightStream ??= _createLightStream();
    return _lightStream!;
  }

  static Stream<double> _createLightStream() {
    const eventChannel = EventChannel('com.example.cirio/light_events');
    return eventChannel.receiveBroadcastStream().map((event) {
      if (event is double) return event;
      if (event is num) return event.toDouble();
      return 0.0;
    });
  }
}
