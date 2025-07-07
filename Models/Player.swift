import Foundation

struct Player: Identifiable, Codable {
    let id = UUID()
    var name: String
    var jerseyNumber: Int
    var position: Position
    var height: String
    var weight: String
    var wingspan: String?
    var age: Int
    var dateOfBirth: Date
    var teamId: String
    var profileImageURL: String?
    var stats: PlayerStats = PlayerStats()
    var gameStats: [GameStats] = []
    var highlightVideos: [VideoHighlight] = []
    
    enum Position: String, CaseIterable, Codable {
        case pointGuard = "Point Guard"
        case shootingGuard = "Shooting Guard"
        case smallForward = "Small Forward"
        case powerForward = "Power Forward"
        case center = "Center"
        
        var abbreviation: String {
            switch self {
            case .pointGuard: return "PG"
            case .shootingGuard: return "SG"
            case .smallForward: return "SF"
            case .powerForward: return "PF"
            case .center: return "C"
            }
        }
    }
}

struct PlayerStats: Codable {
    var gamesPlayed: Int = 0
    var pointsPerGame: Double = 0.0
    var reboundsPerGame: Double = 0.0
    var assistsPerGame: Double = 0.0
    var fieldGoalPercentage: Double = 0.0
    var threePointPercentage: Double = 0.0
    var freeThrowPercentage: Double = 0.0
    var playerEfficiencyRating: Double = 0.0
    var stealsPerGame: Double = 0.0
    var blocksPerGame: Double = 0.0
    var turnoversPerGame: Double = 0.0
}

struct VideoHighlight: Identifiable, Codable {
    let id = UUID()
    var title: String
    var url: String
    var thumbnailURL: String?
    var duration: TimeInterval
    var uploadDate: Date = Date()
    var tags: [String] = []
}
