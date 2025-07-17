package com.example.online_shop

import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    Log.d("SplashDebug", "MainActivity onCreate called")
    super.onCreate(savedInstanceState)
  }
}
