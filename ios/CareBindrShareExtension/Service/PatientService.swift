import Foundation

class PatientService {

    static func getPatients(completion: @escaping ([UserSummary]?, String?) -> Void) {

        guard let token = UserManager.getAccessToken() else {
            completion(nil, "No access token found")
            return
        }

        // ✅ Updated URL (no query params)
        let url = URL(string: "\(APIConfig.baseURL)/users/patients/full-access")!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

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
                    let success = json["success"] as? Bool ?? false

                    if success,
                       let dataArray = json["data"] as? [[String: Any]] {

                        let patients = dataArray.compactMap { UserSummary.fromJson($0) }
                        
                        completion(patients, nil)

                    } else {
                        let message = json["message"] as? String ?? "Failed to fetch patients"
                        completion(nil, message)
                    }
                }
            } catch {
                completion(nil, "Parsing error")
            }

        }.resume()
    }
}
