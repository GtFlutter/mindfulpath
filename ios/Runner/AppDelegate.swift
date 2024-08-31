import UIKit
import Firebase
import Flutter
import flutter_local_notifications


@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      //Notification Setup Start
    FirebaseApp.configure()
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
                GeneratedPluginRegistrant.register(with: registry)
            }
      if #available(iOS 10.0, *) {
                UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
              }
      //Notification Setup End
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
