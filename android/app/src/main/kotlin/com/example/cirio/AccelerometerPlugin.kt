package com.example.cirio

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.os.Handler
import android.os.Looper
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class AccelerometerPlugin : FlutterPlugin, MethodChannel.MethodCallHandler, SensorEventListener {
    private lateinit var methodChannel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private var sensorManager: SensorManager? = null
    private var accelerometerSensor: Sensor? = null
    private var eventSink: EventChannel.EventSink? = null
    private var isListening = false
    private val handler = Handler(Looper.getMainLooper())

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        val context = binding.applicationContext
        
        methodChannel = MethodChannel(binding.binaryMessenger, "com.example.cirio/accelerometer")
        methodChannel.setMethodCallHandler(this)
        
        eventChannel = EventChannel(binding.binaryMessenger, "com.example.cirio/accelerometer_events")
        eventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                eventSink = events
                startListening(context)
            }
            override fun onCancel(arguments: Any?) {
                stopListening()
            }
        })
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        stopListening()
        methodChannel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "isAvailable" -> {
                result.success(accelerometerSensor != null)
            }
            else -> result.notImplemented()
        }
    }

    private fun startListening(context: Context) {
        if (isListening) return
        sensorManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager
        accelerometerSensor = sensorManager?.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)
        accelerometerSensor?.let {
            sensorManager?.registerListener(this, it, SensorManager.SENSOR_DELAY_UI, handler)
            isListening = true
        }
    }

    private fun stopListening() {
        if (!isListening) return
        sensorManager?.unregisterListener(this)
        isListening = false
        eventSink = null
    }

    override fun onSensorChanged(event: SensorEvent?) {
        if (event?.sensor?.type != Sensor.TYPE_ACCELEROMETER) return
        
        val acceleration = Math.sqrt(
            (event.values[0] * event.values[0] + 
             event.values[1] * event.values[1] + 
             event.values[2] * event.values[2]).toDouble()
        )
        
        eventSink?.success(acceleration.toDouble())
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}
}
