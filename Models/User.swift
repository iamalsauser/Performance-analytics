import Foundation
import SwiftUI

enum UserRole: String, CaseIterable {
    case player = "Player"
    case coach = "Coach"
    case manager = "Team Manager"
    case admin = "Admin"
    
    var color: Color {
        switch self {
        case .player: return .blue
        case .coach: return .green
        case .manager: return .orange
        case .admin: return .red
        }
    }
}

struct User: Identifiable, Codable {
    let id = UUID()
    var email: String
    var name: String
    var role: UserRole
    var teamId: String?
    var profileImageURL: String?
    var createdAt: Date = Date()
}
