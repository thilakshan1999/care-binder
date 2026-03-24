import Foundation

class UploadService {

    static func uploadImage(data: Data, fileName: String, completion: @escaping () -> Void) {

        guard let token = UserManager.getAccessToken() else {
            print("❌ No access token found")
            completion()
            return
        }

        let url = URL(string: "https://caresync-service-309965347032.us-central1.run.app/api/vision/extract")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let mimeType = mimeType(for: fileName)

        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(data)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                print("Upload error:", error)
            }
            completion()
        }.resume()
    }

    private static func mimeType(for fileName: String) -> String {
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
}
