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
        
        guard let controller = window?.rootViewController as? FlutterViewController else {
            return super.application(application, didFinishLaunchingWithOptions: launchOptions)
        }
        
        let channel = FlutterMethodChannel(name: "carebinder/share",
                                           binaryMessenger: controller.binaryMessenger)
        
        channel.setMethodCallHandler { [weak self] call, result in
            switch call.method {
            case "getSharedFile":
                if let fileURL = self?.sharedFileURL, let type = self?.sharedFileType {
                    result(["url": fileURL, "type": type])
                    self?.sharedFileURL = nil
                    self?.sharedFileType = nil
                } else {
                    result(nil)
                }
                
            case "deleteSharedFile":
                guard let args = call.arguments as? [String: Any],
                      let fileUrlStr = args["fileUrl"] as? String,
                      let fileUrl = URL(string: fileUrlStr) else {
                    result(FlutterError(code: "INVALID_ARG", message: "Missing fileUrl", details: nil))
                    return
                }
                do {
                    try FileManager.default.removeItem(at: fileUrl)
                    result(nil)
                } catch {
                    result(FlutterError(code: "DELETE_FAILED",
                                        message: "Failed to delete file",
                                        details: error.localizedDescription))
                }
                
            case "clearSharedFolder":
                if let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.hinetics.carebinder.shared") {
                    do {
                        let files = try FileManager.default.contentsOfDirectory(at: container, includingPropertiesForKeys: nil)
                        for file in files {
                            try FileManager.default.removeItem(at: file)
                        }
                        result(nil)
                    } catch {
                        result(FlutterError(code: "CLEAR_FAILED",
                                            message: "Failed to clear folder",
                                            details: error.localizedDescription))
                    }
                } else {
                    result(FlutterError(code: "NO_CONTAINER",
                                        message: "App Group not found",
                                        details: nil))
                }

            default:
                result(FlutterMethodNotImplemented)
            }
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    override func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        
        // ✅ Your custom share parsing logic
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

        // ✅ Forward to Flutter so app_links still receives it
        return super.application(app, open: url, options: options)
    }
}


