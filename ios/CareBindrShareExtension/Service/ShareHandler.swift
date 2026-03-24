import UIKit
import PDFKit
import UniformTypeIdentifiers

class ShareHandler {

    // The controller passes these from UI
    var imageView: UIImageView
    var pdfView: PDFView
    var sharedFileURL: URL?

    init(imageView: UIImageView, pdfView: PDFView) {
        self.imageView = imageView
        self.pdfView = pdfView
    }

    // MARK: - Handle Shared Items
    func handleSharedItems(from extensionContext: NSExtensionContext?) {
        guard let item = extensionContext?.inputItems.first as? NSExtensionItem,
              let attachments = item.attachments else { return }

        for provider in attachments {

            // Image
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

            // File (PDF or other data)
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

    // MARK: - Send File
    func sendFile(completion: @escaping () -> Void) {
        guard let fileURL = sharedFileURL else {
            print("No file found")
            return
        }

        if let type = UTType(filenameExtension: fileURL.pathExtension) {

            if type.conforms(to: .image) {
                compressAndUploadImage(fileURL: fileURL, completion: completion)
            } else if type.conforms(to: .pdf) {
                print("PDF upload not implemented yet")
                completion()
            } else {
                print("Unsupported file type")
                completion()
            }
        }
    }

    // MARK: - Image Compression & Upload
    private func compressAndUploadImage(fileURL: URL, completion: @escaping () -> Void) {
        guard let image = UIImage(contentsOfFile: fileURL.path) else {
            print("Failed to load image")
            return
        }

        guard let compressedData = image.jpegData(compressionQuality: 0.75) else {
            print("Compression failed")
            return
        }

        UploadService.uploadImage(data: compressedData, fileName: "image.jpg") {
            completion()
        }
    }
}
