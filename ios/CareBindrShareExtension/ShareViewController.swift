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

    private func openApp(with url: URL, type: String) {
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.hinetics.carebinder.shared") else {
                close()
                return
            }

            let destURL = containerURL.appendingPathComponent(url.lastPathComponent)
            try? FileManager.default.copyItem(at: url, to: destURL)

            let escapedPath = destURL.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
            let uniqueID = UUID().uuidString
            let scheme = "carebinder://share?type=\(type)&file=\(escapedPath)&uid=\(uniqueID)"
        
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
