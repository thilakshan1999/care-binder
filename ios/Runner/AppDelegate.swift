// import Flutter
// import UIKit

// @main
// @objc class AppDelegate: FlutterAppDelegate {
//   override func application(
//     _ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//   ) -> Bool {
//     GeneratedPluginRegistrant.register(with: self)
//     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//   }
// }
import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
    
    var sharedFileURL: String?
    var sharedFileType: String?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        GeneratedPluginRegistrant.register(with: self)
        
        let controller = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "carebinder/share", binaryMessenger: controller.binaryMessenger)
        
        // Flutter calls this to get the shared file
        channel.setMethodCallHandler { [weak self] call, result in
            if call.method == "getSharedFile" {
                if let fileURL = self?.sharedFileURL, let type = self?.sharedFileType {
                    result(["url": fileURL, "type": type])
                    self?.sharedFileURL = nil
                    self?.sharedFileType = nil
                } else {
                    result(nil)
                }
            }
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    // Handle URL scheme
    override func application(_ app: UIApplication, open url: URL,
                              options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        if components?.host == "share", let queryItems = components?.queryItems {
            for item in queryItems {
                if item.name == "file" {
                    sharedFileURL = item.value
                } else if item.name == "type" {
                    sharedFileType = item.value
                }
            }
        }
        return true
    }
}
