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

    // MARK: - Send Action
    @objc private func sendTapped() {

        print("Send tapped 🚀")
        print("File: \(sharedFileURL?.lastPathComponent ?? "No file")")

        close()
    }
    
    @objc private func closeTapped() {
        close()
    }

    private func close() {
        extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }
}
