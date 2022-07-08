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
  // private static final String CHANNEL = "https.bausch-lomb.in-progress.ru/channel";

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    MapKitFactory.setLocale("ru_RU")
    MapKitFactory.setApiKey("7d7c37af-b634-485a-8642-40caa8f296b8") // API_KEY
    super.configureFlutterEngine(flutterEngine)
  }

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
      processMindboxIntent(intent)
  //     GeneratedPluginRegistrant.registerWith(this);

  // Uri data = intent.getData();

  // new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
  //         new MethodChannel.MethodCallHandler() {
  //           @Override
  //           public void onMethodCall(MethodCall call, MethodChannel.Result result) {
  //             if (call.method.equals("initialLink")) {
  //               if (startString != null) {
  //                 result.success(startString);
  //               }
  //             }
  //           }
  //         });

  // if (data != null) {
  //   startString = data.toString();
  // }
    }

  override fun onNewIntent(intent: Intent) {
    super.onNewIntent(intent)
      processMindboxIntent(intent)
      //   if(intent.getAction() == android.content.Intent.ACTION_VIEW && linksReceiver != null) {
      // linksReceiver.onReceive(this.getApplicationContext(), intent);
    }
    }

  //   private BroadcastReceiver createChangeReceiver(final EventChannel.EventSink events) {
  //   return new BroadcastReceiver() {
  //     @Override
  //     public void onReceive(Context context, Intent intent) {
  //       // NOTE: assuming intent.getAction() is Intent.ACTION_VIEW

  //       String dataString = intent.getDataString();

  //       if (dataString == null) {
  //         events.error("UNAVAILABLE", "Link unavailable", null);
  //       } else {
  //         events.success(dataString);
  //       }
  //       ;
  //     }
  //   };
  // }

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