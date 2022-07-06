import UIKit
import Flutter
import FirebaseCore
import YandexMapsMobile
import mindbox_ios

@UIApplicationMain
@objc class AppDelegate: MindboxFlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    YMKMapKit.setLocale("ru_RU")
    YMKMapKit.setApiKey("7d7c37af-b634-485a-8642-40caa8f296b8") // API_KEY
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
