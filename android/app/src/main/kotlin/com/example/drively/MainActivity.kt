package com.example.drively

import android.os.Bundle
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    // Create a new FlutterEngine instance
    val flutterEngine = FlutterEngine(this)
    GeneratedPluginRegistrant.registerWith(flutterEngine)

    // Enable full-screen notifications
    window.addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)
    window.addFlags(WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED)
    window.addFlags(WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON)
  }

  override fun getFlutterEngine(): FlutterEngine? {
    // Return the FlutterEngine instance
    return flutterEngine
  }
}
