import Foundation

struct Game: Identifiable, Codable {
    let id = UUID()
    var homeTeamId: String
    var awayTeamId: String
    var homeScore: Int = 0
    var awayScore: Int = 0
    var quarter: Int = 1
    var timeRemaining: TimeInterval = 12 * 60 // 12 minutes in seconds
    var isLive: Bool = false
    var isCompleted: Bool = false
    var date: Date = Date()
    var playerStats: [GameStats] = []
}
