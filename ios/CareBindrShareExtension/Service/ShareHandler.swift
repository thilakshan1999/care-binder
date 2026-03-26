import UIKit
import PDFKit
import UniformTypeIdentifiers

class ShareHandler {

    var imageView: UIImageView
    var pdfView: PDFView
    var sharedFileURL: URL?

    var selectedPatientId: String?

    init(imageView: UIImageView, pdfView: PDFView) {
        self.imageView = imageView
        self.pdfView = pdfView
    }

    // MARK: - Handle Shared Items
    func handleSharedItems(from extensionContext: NSExtensionContext?) {
        guard let item = extensionContext?.inputItems.first as? NSExtensionItem,
              let attachments = item.attachments else { return }

        for provider in attachments {

            if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                provider.loadItem(forTypeIdentifier: UTType.image.identifier, options: nil) { item, _ in
                    DispatchQueue.main.async {
                        if let url = item as? URL {
                            self.sharedFileURL = url
                            
                            self.imageView.image = UIImage(contentsOfFile: url.path)
                        } else if let image = item as? UIImage {
                            let tempURL = self.saveTempImage(image: image)
                            self.sharedFileURL = tempURL
                            self.imageView.image = image
                        }
                    }
                }
                return
            }

            if provider.hasItemConformingToTypeIdentifier(UTType.data.identifier) {
                provider.loadItem(forTypeIdentifier: UTType.data.identifier, options: nil) { item, _ in
                    DispatchQueue.main.async {
                        if let url = item as? URL {
                            self.sharedFileURL = url

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
    func sendFile(completion: @escaping (Bool, String?) -> Void) {
        guard let fileURL = sharedFileURL else {
            completion(false, "No file selected")
            return
        }

        guard let uploadURL = copyToSharedContainer(from: fileURL) else {
            completion(false, "Failed to prepare file")
            return
        }

        guard let type = UTType(filenameExtension: uploadURL.pathExtension) else {
            completion(false, "Unsupported file type")
            return
        }

        if type.conforms(to: .image) {
            uploadImage(fileURL: uploadURL, completion: completion)
        } else if type.conforms(to: .pdf) {
            uploadPDF(fileURL: uploadURL, completion: completion)
        } else {
            completion(false, "Unsupported file type")
        }
    }

    // MARK: - Upload Image
    private func uploadImage(fileURL: URL, completion: @escaping (Bool, String?) -> Void) {

        guard let image = UIImage(contentsOfFile: fileURL.path),
              let data = image.jpegData(compressionQuality: 0.75) else {
            completion(false, "Image processing failed")
            return
        }

        UploadService.uploadDocument(
            fileData: data,
            fileName: fileURL.lastPathComponent,
            mimeType: "image/jpeg",
            patientId: selectedPatientId
        ) { success, error in
            
            if success {
                completion(true, nil)
            } else {
                completion(false, error ?? "Upload failed")
            }
        }
    }

    // MARK: - Upload PDF
    private func uploadPDF(fileURL: URL, completion: @escaping (Bool, String?) -> Void) {

        do {
            let data = try Data(contentsOf: fileURL)

            UploadService.uploadDocument(
                fileData: data,
                fileName: fileURL.lastPathComponent,
                mimeType: "application/pdf",
                patientId: selectedPatientId
            ) { success, error in
                
                if success {
                    completion(true, nil)
                } else {
                    completion(false, error ?? "Upload failed")
                }
            }

        } catch {
            completion(false, "Failed to read PDF")
        }
    }

    // MARK: - Copy File to Shared Container (🔥 CRITICAL)
    private func copyToSharedContainer(from url: URL) -> URL? {
        guard let containerURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: "group.com.hinetics.carebinder.shared"
        ) else {
            return nil
        }

        let fileName = url.lastPathComponent
        let destURL = containerURL.appendingPathComponent(fileName)

        // Remove if exists
        if FileManager.default.fileExists(atPath: destURL.path) {
            try? FileManager.default.removeItem(at: destURL)
        }

        do {
            try FileManager.default.copyItem(at: url, to: destURL)
            return destURL
        } catch {
            print("❌ Copy failed:", error)
            return nil
        }
    }

    // MARK: - Save UIImage as Temp File
    private func saveTempImage(image: UIImage) -> URL? {
        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString + ".jpg")

        if let data = image.jpegData(compressionQuality: 0.9) {
            try? data.write(to: tempURL)
            return tempURL
        }
        return nil
    }
}
