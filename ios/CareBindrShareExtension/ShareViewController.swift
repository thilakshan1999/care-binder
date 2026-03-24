//import UIKit
//import UniformTypeIdentifiers
//
//class ShareViewController: UIViewController {
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        handleSharedItems()
//    }
//
//    private func handleSharedItems() {
//        guard let item = extensionContext?.inputItems.first as? NSExtensionItem,
//              let attachments = item.attachments else {
//            close()
//            return
//        }
//
//        for provider in attachments {
//            // 🖼 Handle images
//            if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
//                provider.loadItem(forTypeIdentifier: UTType.image.identifier, options: nil) { item, _ in
//                    if let url = item as? URL {
//                        self.openApp(with: url, type: "image")
//                    } else if let image = item as? UIImage,
//                              let data = image.pngData() {
//                        let temp = FileManager.default.temporaryDirectory.appendingPathComponent("shared.png")
//                        try? data.write(to: temp)
//                        self.openApp(with: temp, type: "image")
//                    } else {
//                        self.close()
//                    }
//                }
//                return
//            }
//
//            // 📄 Handle PDF or other files
//            if provider.hasItemConformingToTypeIdentifier(UTType.pdf.identifier) ||
//               provider.hasItemConformingToTypeIdentifier(UTType.data.identifier) {
//                provider.loadItem(forTypeIdentifier: UTType.data.identifier, options: nil) { item, _ in
//                    if let url = item as? URL {
//                        self.openApp(with: url, type: "file")
//                    } else {
//                        self.close()
//                    }
//                }
//                return
//            }
//        }
//
//        // No supported item found
//        close()
//    }
//
//    private func openApp(with url: URL, type: String) {
//        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.hinetics.carebinder.shared") else {
//                close()
//                return
//            }
//
//            let destURL = containerURL.appendingPathComponent(url.lastPathComponent)
//            try? FileManager.default.copyItem(at: url, to: destURL)
//
//            let escapedPath = destURL.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
//        
//            let uniqueID = UUID().uuidString
//            let scheme = "carebinder://share?type=\(type)&file=\(escapedPath)&uid=\(uniqueID)"
//        
//        if let appURL = URL(string: scheme) {
//            var responder: UIResponder? = self
//            while let r = responder {
//                if let app = r as? UIApplication {
//                    if #available(iOS 10.0, *) {
//                        app.open(appURL, options: [:], completionHandler: nil)
//                    }
//                    break
//                }
//                responder = r.next
//            }
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            self.close()
//        }
//    }
//
//    private func close() {
//        self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
//    }
//}

import UIKit
import UniformTypeIdentifiers
import PDFKit
import UniformTypeIdentifiers

class ShareViewController: UIViewController {

    private let imageView = UIImageView()
    private let pdfView = PDFView()
    private let sendButton = UIButton(type: .system)
    private let closeButton = UIButton(type: .system)

    private var sharedFileURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        handleSharedItems()
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white

        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        pdfView.backgroundColor = .white
        pdfView.documentView?.backgroundColor = .white
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        pdfView.autoScales = true
        pdfView.isHidden = true
        
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
        let image = UIImage(systemName: "xmark", withConfiguration: config)
        closeButton.setImage(image, for: .normal)
        closeButton.tintColor = .label
        closeButton.backgroundColor = UIColor.systemGray5
        closeButton.layer.cornerRadius = 16
        closeButton.clipsToBounds = true
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)

        sendButton.setTitle("Send", for: .normal)
        sendButton.setTitleColor(.white, for: .normal)
        sendButton.backgroundColor = UIColor.systemBlue // Primary color
        sendButton.layer.cornerRadius = 12
        sendButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)

        view.addSubview(closeButton)
        view.addSubview(imageView)
        view.addSubview(sendButton)
        view.addSubview(pdfView)

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 32),
            closeButton.heightAnchor.constraint(equalToConstant: 32),
            
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            imageView.bottomAnchor.constraint(equalTo: sendButton.topAnchor, constant: -20),
            
            pdfView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 16),
            pdfView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            pdfView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            pdfView.bottomAnchor.constraint(equalTo: sendButton.topAnchor, constant: -20),

            sendButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            sendButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            sendButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK: - Handle Shared Content
    private func handleSharedItems() {
        guard let item = extensionContext?.inputItems.first as? NSExtensionItem,
              let attachments = item.attachments else {
            return
        }

        for provider in attachments {

            // Handle Image
            if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                provider.loadItem(forTypeIdentifier: UTType.image.identifier, options: nil) { item, _ in
                    DispatchQueue.main.async {
                        if let url = item as? URL {
                            self.sharedFileURL = url
                            self.imageView.image = UIImage(contentsOfFile: url.path)
                        } else if let image = item as? UIImage {
                            self.imageView.image = image
                        }
                    }
                }
                return
            }

            // Handle File (PDF etc.)
            if provider.hasItemConformingToTypeIdentifier(UTType.data.identifier) {
                provider.loadItem(forTypeIdentifier: UTType.data.identifier, options: nil) { item, _ in
                    DispatchQueue.main.async {
                        if let url = item as? URL {
                            self.sharedFileURL = url

                            // Show PDF
                            self.imageView.isHidden = true
                            self.pdfView.isHidden = false

                            if let pdfDoc = PDFDocument(url: url) {
                                self.pdfView.document = pdfDoc
                            }
                        }
                    }
                }
                return
            }
        }
    }

    @objc private func sendTapped() {
        guard let fileURL = sharedFileURL else {
            print("No file found")
            return
        }

        if let type = UTType(filenameExtension: fileURL.pathExtension) {
            
            if type.conforms(to: .image) {
                compressAndUploadImage(fileURL: fileURL)
            } else if type.conforms(to: .pdf) {
                print("PDF upload not implemented yet")
                close()
            } else {
                print("Unsupported file type")
                close()
            }
        }
    }
    
    @objc private func closeTapped() {
        close()
    }
    
    private func compressAndUploadImage(fileURL: URL) {
        guard let image = UIImage(contentsOfFile: fileURL.path) else {
            print("Failed to load image")
            return
        }

        guard let compressedData = image.jpegData(compressionQuality: 0.75) else {
            print("Compression failed")
            return
        }

        uploadImage(data: compressedData, fileName: "image.jpg")
    }
    
    private func uploadImage(data: Data, fileName: String) {
        guard let token = getAccessToken() else {
               print("❌ No access token found")
               close()
               return
           }
        
        let url = URL(string: "https://caresync-service-309965347032.us-central1.run.app/api/vision/extract")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // ✅ Add Authorization header
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let mimeType = mimeType(for: fileName)
        var body = Data()
        // Add file
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(data)
        body.append("\r\n".data(using: .utf8)!)

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Upload error:", error)
                return
            }

            guard let data = data else {
                print("No response data")
                return
            }

            let responseString = String(data: data, encoding: .utf8) ?? ""
            print("API Response:", responseString)

            DispatchQueue.main.async {
                self.close()
            }
        }

        task.resume()
    }
    
    private func getAccessToken() -> String? {
        let defaults = UserDefaults(suiteName: "group.com.hinetics.carebinder.shared")
        return defaults?.string(forKey: "access_token")
    }
    
    private func mimeType(for fileName: String) -> String {
        let ext = (fileName as NSString).pathExtension.lowercased()
        switch ext {
        case "jpg", "jpeg": return "image/jpeg"
        case "png": return "image/png"
        case "gif": return "image/gif"
        case "bmp": return "image/bmp"
        case "webp": return "image/webp"
        case "pdf": return "application/pdf"
        default: return "application/octet-stream"
        }
    }

    private func close() {
        extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }
}
