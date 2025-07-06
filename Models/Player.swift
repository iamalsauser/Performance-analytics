import Foundation

struct Player: Identifiable, Codable {
    let id = UUID()
    var name: String
    var jerseyNumber: Int
    var position: Position
    var height: String
    var weight: String
    var dateOfBirth: Date
    var dominantHand: Hand
    var teamId: String
    var profileImageURL: String?
    var stats: [GameStats] = []
    
    enum Position: String, CaseIterable {
        case pointGuard = "Point Guard"
        case shootingGuard = "Shooting Guard"
        case smallForward = "Small Forward"
        case powerForward = "Power Forward"
        case center = "Center"
    }
    
    enum Hand: String, CaseIterable {
        case left = "Left"
        case right = "Right"
        case ambidextrous = "Ambidextrous"
    }
}
