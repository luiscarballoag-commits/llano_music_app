package com.example.llano_music_app

import android.content.Context
import androidx.annotation.NonNull
import com.ryanheise.audioservice.AudioServicePlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun provideFlutterEngine(@NonNull context: Context): FlutterEngine? {
        return AudioServicePlugin.getFlutterEngine(context)
    }
}
