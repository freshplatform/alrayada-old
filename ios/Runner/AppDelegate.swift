import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
      let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
      let bundleIdentifier = Bundle.main.bundleIdentifier ?? ""
      let appChannel = FlutterMethodChannel(name: "\(bundleIdentifier)/app", binaryMessenger: controller.binaryMessenger)
      appChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            // This method is invoked on the UI thread.
          switch call.method {
          case "setWindowPrivate":
//              let secureWindow = call.arguments as? Bool ?? false
            // TODO("Implement")
              result(true)
              break;
          case "getPackageInfo":
              var appInfo: [String: Any] = [:]

              if let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String,
                 let buildNumberString = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String,
                 let buildNumber = Int(buildNumberString),
                 let versionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
                  appInfo["packageName"] = appName
                  appInfo["buildNumber"] = buildNumber
                  appInfo["buildName"] = versionNumber
              }
              result(appInfo)
              break;
          case "shareText":
              let arguments = call.arguments as? [String: String] ?? [:]
              let text = arguments["text"] ?? "";
              
              let subject = arguments["subject"] ?? ""

              let link = URL(string: text)!

              let activityViewController = UIActivityViewController(activityItems: [link,
                subject], applicationActivities: nil)

              activityViewController.setValue(subject, forKey: "subject")

              // Customize the activity view controller, if needed

              if let window = UIApplication.shared.windows.first,
                 let rootViewController = window.rootViewController {
                  rootViewController.present(activityViewController, animated: true, completion: nil)
                  result(true)
                  return
              }
              result(false)

              break;
          default:
              break;
          }
          })
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
