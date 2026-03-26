import Foundation

class UploadService {
    static func uploadDocument(
            fileData: Data,
            fileName: String,
            mimeType: String,
            patientId: String?, // optional
            completion: @escaping (Bool, String?) -> Void
        ) {
            
            guard let token = UserManager.getAccessToken() else {
                completion(false, "No access token")
                return
            }
            
            let url = URL(string: "\(APIConfig.baseURL)/share/process")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            // ✅ Headers
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            // ✅ Multipart boundary
            let boundary = UUID().uuidString
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            // ✅ Body
            var body = Data()
            
            // File part
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
            body.append(fileData)
            body.append("\r\n".data(using: .utf8)!)
            
            // Optional patientId
            if let patientId = patientId {
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"patientId\"\r\n\r\n".data(using: .utf8)!)
                body.append("\(patientId)\r\n".data(using: .utf8)!)
            }
            
            // End boundary
            body.append("--\(boundary)--\r\n".data(using: .utf8)!)
            
            request.httpBody = body
            
            // ✅ Call API
            URLSession.shared.dataTask(with: request) { data, response, error in
                
                if let error = error {
                    completion(false, error.localizedDescription)
                    return
                }
                
                guard let data = data else {
                    completion(false, "No response data")
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        
                        let success = (json["success"] as? Bool) ?? ((json["success"] as? Int) == 1)
                        let message = json["message"] as? String
                        
                        if success {
                            completion(true, nil)
                        } else {
                            completion(false, message ?? "Upload failed")
                        }
                    }
                } catch {
                    completion(false, "Parsing error")
                }
                
            }.resume()
        }
}
