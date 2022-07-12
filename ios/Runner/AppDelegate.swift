import UIKit
import Flutter
// import FirebaseCore
import YandexMapsMobile
import mindbox_ios

@UIApplicationMain
@objc class AppDelegate: MindboxFlutterAppDelegate {
  //  private var eventChannel: FlutterEventChannel?
  
 // private let linkStreamHandler = LinkStreamHandler()
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // FirebaseApp.configure()
    YMKMapKit.setLocale("ru_RU")
    YMKMapKit.setApiKey("7d7c37af-b634-485a-8642-40caa8f296b8") // API_KEY

    //  let controller = window.rootViewController as! FlutterViewController
    // methodChannel = FlutterMethodChannel(name: "https.bausch-lomb.in-progress.ru/channel", binaryMessenger: controller)
   
    // methodChannel?.setMethodCallHandler({ (call: FlutterMethodCall, result: FlutterResult) in
    //   guard call.method == "initialLink" else {
    //     result(FlutterMethodNotImplemented)
    //     return
    //   }
    // })
    
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  //   override func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
  //   eventChannel?.setStreamHandler(linkStreamHandler)
  //   return linkStreamHandler.handleLink(url.absoluteString)
  // }
}

// class LinkStreamHandler:NSObject, FlutterStreamHandler {
  
//   var eventSink: FlutterEventSink?
  
//   // links will be added to this queue until the sink is ready to process them
//   var queuedLinks = [String]()
  
//   func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
//     self.eventSink = events
//     queuedLinks.forEach({ events($0) })
//     queuedLinks.removeAll()
//     return nil
//   }
  
//   func onCancel(withArguments arguments: Any?) -> FlutterError? {
//     self.eventSink = nil
//     return nil
//   }
  
//   func handleLink(_ link: String) -> Bool {
//     guard let eventSink = eventSink else {
//       queuedLinks.append(link)
//       return false
//     }
//     eventSink(link)
//     return true
//   }
// }
