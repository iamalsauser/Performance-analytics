import Foundation

struct Team: Identifiable, Codable {
    let id = UUID()
    var name: String
    var logoURL: String?
    var players: [Player] = []
    var coachId: String?
    var managerId: String?
    var games: [Game] = []
    var createdAt: Date = Date()
}
