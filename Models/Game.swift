import Foundation

struct Game: Identifiable, Codable {
    let id = UUID()
    var homeTeamId: String
    var awayTeamId: String
    var homeTeamName: String
    var awayTeamName: String
    var homeScore: Int = 0
    var awayScore: Int = 0
    var quarter: Int = 1
    var timeRemaining: TimeInterval = 12 * 60 // 12 minutes in seconds
    var isLive: Bool = false
    var isCompleted: Bool = false
    var date: Date = Date()
    var venue: String = ""
    var playerStats: [GameStats] = []
    var quarterScores: [[Int]] = [[0, 0], [0, 0], [0, 0], [0, 0]] // [home, away] for each quarter
}

struct GameStats: Identifiable, Codable {
    let id = UUID()
    var playerId: UUID
    var gameId: UUID
    var minutesPlayed: Int = 0
    
    // Shooting Stats
    var fieldGoalsMade: Int = 0
    var fieldGoalsAttempted: Int = 0
    var threePointersMade: Int = 0
    var threePointersAttempted: Int = 0
    var freeThrowsMade: Int = 0
    var freeThrowsAttempted: Int = 0
    
    // Other Stats
    var offensiveRebounds: Int = 0
    var defensiveRebounds: Int = 0
    var assists: Int = 0
    var steals: Int = 0
    var blocks: Int = 0
    var turnovers: Int = 0
    var personalFouls: Int = 0
    
    // Calculated Properties
    var totalRebounds: Int { offensiveRebounds + defensiveRebounds }
    var points: Int { (fieldGoalsMade - threePointersMade) * 2 + threePointersMade * 3 + freeThrowsMade }
    var fieldGoalPercentage: Double { 
        fieldGoalsAttempted > 0 ? Double(fieldGoalsMade) / Double(fieldGoalsAttempted) * 100 : 0 
    }
    var threePointPercentage: Double { 
        threePointersAttempted > 0 ? Double(threePointersMade) / Double(threePointersAttempted) * 100 : 0 
    }
    var freeThrowPercentage: Double { 
        freeThrowsAttempted > 0 ? Double(freeThrowsMade) / Double(freeThrowsAttempted) * 100 : 0 
    }
    var playerEfficiencyRating: Double {
        let per = Double(points + totalRebounds + assists + steals + blocks - (fieldGoalsAttempted - fieldGoalsMade) - (freeThrowsAttempted - freeThrowsMade) - turnovers)
        return max(0, per)
    }
}
