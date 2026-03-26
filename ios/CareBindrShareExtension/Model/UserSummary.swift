struct UserSummary {
    let id: String
    let name: String
    let email: String

    static func fromJson(_ json: [String: Any]) -> UserSummary? {
        guard let idInt = json["id"] as? Int,
              let name = json["name"] as? String,
              let email = json["email"] as? String else {
            return nil
        }

        return UserSummary(
            id: String(idInt), // ✅ convert Int → String
            name: name,
            email: email
        )
    }
}
