package mobile.bausch

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import com.yandex.mapkit.MapKitFactory


class MainActivity: FlutterActivity() {
  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    MapKitFactory.setLocale("ru_RU")
    MapKitFactory.setApiKey("7d7c37af-b634-485a-8642-40caa8f296b8") // API_KEY
    super.configureFlutterEngine(flutterEngine)
  }
}