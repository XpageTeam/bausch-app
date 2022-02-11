package mobile.bausch

import android.content.Intent
import android.os.Bundle
import androidx.annotation.NonNull
import cloud.mindbox.mindbox_android.MindboxAndroidPlugin
import cloud.mindbox.mobile_sdk.Mindbox
import com.yandex.mapkit.MapKitFactory
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine


class MainActivity: FlutterActivity() {
  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    MapKitFactory.setLocale("ru_RU")
    MapKitFactory.setApiKey("7d7c37af-b634-485a-8642-40caa8f296b8") // API_KEY
    super.configureFlutterEngine(flutterEngine)
  }

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
      processMindboxIntent(intent)
    }

  override fun onNewIntent(intent: Intent) {
    super.onNewIntent(intent)
      processMindboxIntent(intent)
    }

  private fun processMindboxIntent(intent: Intent?) {
    intent?.let {
      // Проверяем, что интент - это пуш Mindbox
      val uniqueKey = intent.getStringExtra("uniq_push_key")
        if (uniqueKey != null) {
        Mindbox.onPushClicked(this, it)
          Mindbox.onNewIntent(it)
          // Передача ссылки из пуша во Flutter
          val link = Mindbox.getUrlFromPushIntent(intent) ?: ""
          MindboxAndroidPlugin.pushClicked(link)

        }
    }
  }
}