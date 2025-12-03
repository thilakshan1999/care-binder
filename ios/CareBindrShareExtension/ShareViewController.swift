//
//  ShareViewController.swift
//  CareBindrShareExtension
//
//  Created by Kathiramalai Thilakshan on 2025-11-25.
//

//import UIKit
//import Social
//
//class ShareViewController: SLComposeServiceViewController {
//
//    override func isContentValid() -> Bool {
//        // Do validation of contentText and/or NSExtensionContext attachments here
//        return true
//    }
//
//    override func didSelectPost() {
//        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
//    
//        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
//        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
//    }
//
//    override func configurationItems() -> [Any]! {
//        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
//        return []
//    }
//
//}


import UIKit
import UniformTypeIdentifiers

class ShareViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleSharedItems()
    }

    private func handleSharedItems() {
        guard let item = extensionContext?.inputItems.first as? NSExtensionItem,
              let attachments = item.attachments else {
            close()
            return
        }

        for provider in attachments {
            // 🖼 Handle images
            if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                provider.loadItem(forTypeIdentifier: UTType.image.identifier, options: nil) { item, _ in
                    if let url = item as? URL {
                        self.openApp(with: url, type: "image")
                    } else if let image = item as? UIImage,
                              let data = image.pngData() {
                        let temp = FileManager.default.temporaryDirectory.appendingPathComponent("shared.png")
                        try? data.write(to: temp)
                        self.openApp(with: temp, type: "image")
                    } else {
                        self.close()
                    }
                }
                return
            }

            // 📄 Handle PDF or other files
            if provider.hasItemConformingToTypeIdentifier(UTType.pdf.identifier) ||
               provider.hasItemConformingToTypeIdentifier(UTType.data.identifier) {
                provider.loadItem(forTypeIdentifier: UTType.data.identifier, options: nil) { item, _ in
                    if let url = item as? URL {
                        self.openApp(with: url, type: "file")
                    } else {
                        self.close()
                    }
                }
                return
            }
        }

        // No supported item found
        close()
    }

//    private func openApp(with url: URL, type: String) {
//        let escapedPath = url.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
//        let scheme = "carebinder://share?type=\(type)&file=\(escapedPath)"
//
//        guard let appURL = URL(string: scheme) else {
//            close()
//            return
//        }
//
//        // Open app via responder chain
//        var responder: UIResponder? = self
//        while let r = responder {
//            if let application = r as? UIApplication {
//                if #available(iOS 10.0, *) {
//                    application.open(appURL, options: [:], completionHandler: nil)
//                }
//                break
//            }
//            responder = r.next
//        }
//
//        // Close extension shortly after
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            self.close()
//        }
//    }
    private func openApp(with url: URL, type: String) {
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.hinetics.carebinder.shared") else {
                close()
                return
            }

            let destURL = containerURL.appendingPathComponent(url.lastPathComponent)
            try? FileManager.default.copyItem(at: url, to: destURL)

            let escapedPath = destURL.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let scheme = "carebinder://share?type=\(type)&file=\(escapedPath)"
        
        if let appURL = URL(string: scheme) {
            var responder: UIResponder? = self
            while let r = responder {
                if let app = r as? UIApplication {
                    if #available(iOS 10.0, *) {
                        app.open(appURL, options: [:], completionHandler: nil)
                    }
                    break
                }
                responder = r.next
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.close()
        }
    }

    private func close() {
        self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }
}
