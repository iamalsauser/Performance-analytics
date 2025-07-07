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
    var teamStats: TeamStats = TeamStats()
}

struct TeamStats: Codable {
    var gamesPlayed: Int = 0
    var wins: Int = 0
    var losses: Int = 0
    var averagePoints: Double = 0.0
    var averagePointsAllowed: Double = 0.0
    var fieldGoalPercentage: Double = 0.0
    var threePointPercentage: Double = 0.0
    var freeThrowPercentage: Double = 0.0
    var reboundsPerGame: Double = 0.0
    var assistsPerGame: Double = 0.0
    var turnoversPerGame: Double = 0.0
    
    var winPercentage: Double {
        gamesPlayed > 0 ? Double(wins) / Double(gamesPlayed) * 100 : 0
    }
}
