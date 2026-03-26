import Foundation

class UserManager {

    private static let suiteName = "group.com.hinetics.carebinder.shared"
    private static var defaults: UserDefaults? {
        return UserDefaults(suiteName: suiteName)
    }

    // MARK: - Access Token
    static func getAccessToken() -> String? {
        return defaults?.string(forKey: "access_token")
    }

    static func saveAccessToken(_ token: String) {
            defaults?.set(token, forKey: "access_token")
    }
    
    // MARK: - Refresh Token
    static func getRefreshToken() -> String? {
        return defaults?.string(forKey: "refresh_token")
    }

    // MARK: - Username
    static func getUserName() -> String? {
        return defaults?.string(forKey: "username")
    }

    // MARK: - User Role
    static func getUserRole() -> String? {
        return defaults?.string(forKey: "role")
    }

    // MARK: - Clear all data
    static func clearAll() {
        defaults?.removeObject(forKey: "access_token")
        defaults?.removeObject(forKey: "refresh_token")
        defaults?.removeObject(forKey: "username")
        defaults?.removeObject(forKey: "role")
    }
}

extension UserManager {

    static func isAccessTokenExpired() -> Bool {
        guard let token = getAccessToken() else {
            return true
        }

        let segments = token.split(separator: ".")
        guard segments.count > 1 else { return true }

        let payloadSegment = segments[1]

        var base64 = String(payloadSegment)
        base64 = base64.replacingOccurrences(of: "-", with: "+")
        base64 = base64.replacingOccurrences(of: "_", with: "/")

        let paddedLength = 4 * ((base64.count + 3) / 4)
        base64 = base64.padding(toLength: paddedLength, withPad: "=", startingAt: 0)

        guard let data = Data(base64Encoded: base64),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let exp = json["exp"] as? TimeInterval else {
            return true
        }

        let expiryDate = Date(timeIntervalSince1970: exp)

        return Date() >= expiryDate.addingTimeInterval(-60) // buffer
    }
}
