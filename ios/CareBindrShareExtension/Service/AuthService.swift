import Foundation

class AuthService {

    static func refreshToken(completion: @escaping (String?, String?) -> Void) {

        guard let refreshToken = UserManager.getRefreshToken() else {
            completion(nil, "No refresh token found")
            return
        }

        let url = URL(string: "\(APIConfig.baseURL)/users/refresh-token")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "refreshToken": refreshToken
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(nil, "Network error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                completion(nil, "No data received")
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    
                    if let success = json["success"] as? Int, success == 1,
                       let dataObj = json["data"] as? [String: Any],
                       let newAccessToken = dataObj["accessToken"] as? String {

                        print("acess token")
                        print(newAccessToken)
                        UserManager.saveAccessToken(newAccessToken)
                        completion(newAccessToken, nil)

                    } else {
                        let message = json["message"] as? String ?? "Unknown error"
                        completion(nil, message)
                    }
                }
            } catch {
                completion(nil, "Parsing error")
            }
        }.resume()
    }
}
