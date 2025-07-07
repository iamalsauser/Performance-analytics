import Foundation
import SwiftUI

enum UserRole: String, CaseIterable, Codable {
    case player = "Player"
    case coach = "Coach"
    case manager = "Team Manager"
    
    var color: Color {
        switch self {
        case .player: return .blue
        case .coach: return .green
        case .manager: return .orange
        }
    }
    
    var icon: String {
        switch self {
        case .player: return "person.fill"
        case .coach: return "person.3.fill"
        case .manager: return "briefcase.fill"
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
    var isFirstLogin: Bool = true
}
