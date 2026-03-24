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
