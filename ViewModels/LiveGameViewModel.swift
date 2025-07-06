import Foundation
import SwiftUI

enum StatType {
    case fieldGoalMade, fieldGoalMissed
    case threePointerMade, threePointerMissed
    case freeThrowMade, freeThrowMissed
    case rebound, assist, steal, block, turnover, foul
}

@MainActor
class LiveGameViewModel: ObservableObject {
    @Published var currentGame = Game(homeTeamId: "home", awayTeamId: "away")
    @Published var gameTimer: Timer?
    
    private var statHistory: [StatAction] = []
    
    struct StatAction {
        let playerId: UUID
        let statType: StatType
        let value: Int
        let timestamp: Date
    }
    
    func startPauseGame() {
        currentGame.isLive.toggle()
        
        if currentGame.isLive {
            startTimer()
        } else {
            stopTimer()
        }
    }
    
    func resetClock() {
        currentGame.timeRemaining = 12 * 60 // 12 minutes
        stopTimer()
        currentGame.isLive = false
    }
    
    func nextQuarter() {
        if currentGame.quarter < 4 {
            currentGame.quarter += 1
            currentGame.timeRemaining = 12 * 60
        } else {
            endGame()
        }
    }
    
    func endGame() {
        stopTimer()
        currentGame.isLive = false
        currentGame.isCompleted = true
    }
    
    func updateStat(_ playerId: UUID, _ statType: StatType, _ value: Int) {
        // Record the action for undo functionality
        let action = StatAction(playerId: playerId, statType: statType, value: value, timestamp: Date())
        statHistory.append(action)
        
        // Find or create player stats
        if let index = currentGame.playerStats.firstIndex(where: { $0.playerId == playerId }) {
            updatePlayerStat(&currentGame.playerStats[index], statType, value)
        } else {
            var newStats = GameStats(playerId: playerId, gameId: currentGame.id)
            updatePlayerStat(&newStats, statType, value)
            currentGame.playerStats.append(newStats)
        }
        
        // Update game score if needed
        updateGameScore(statType, value)
    }
    
    func undoLastAction() {
        guard let lastAction = statHistory.popLast() else { return }
        
        if let index = currentGame.playerStats.firstIndex(where: { $0.playerId == lastAction.playerId }) {
            updatePlayerStat(&currentGame.playerStats[index], lastAction.statType, -lastAction.value)
        }
        
        updateGameScore(lastAction.statType, -lastAction.value)
    }
    
    private func startTimer() {
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            Task { @MainActor in
                if self.currentGame.timeRemaining > 0 {
                    self.currentGame.timeRemaining -= 1
                } else {
                    self.nextQuarter()
                }
            }
        }
    }
    
    private func stopTimer() {
        gameTimer?.invalidate()
        gameTimer = nil
    }
    
    private func updatePlayerStat(_ stats: inout GameStats, _ statType: StatType, _ value: Int) {
        switch statType {
        case .fieldGoalMade:
            stats.fieldGoalsMade += value
            stats.fieldGoalsAttempted += value
        case .fieldGoalMissed:
            stats.fieldGoalsAttempted += value
        case .threePointerMade:
            stats.threePointersMade += value
            stats.threePointersAttempted += value
            stats.fieldGoalsMade += value
            stats.fieldGoalsAttempted += value
        case .threePointerMissed:
            stats.threePointersAttempted += value
            stats.fieldGoalsAttempted += value
        case .freeThrowMade:
            stats.freeThrowsMade += value
            stats.freeThrowsAttempted += value
        case .freeThrowMissed:
            stats.freeThrowsAttempted += value
        case .rebound:
            stats.defensiveRebounds += value
        case .assist:
            stats.assists += value
        case .steal:
            stats.steals += value
        case .block:
            stats.blocks += value
        case .turnover:
            stats.turnovers += value
        case .foul:
            stats.personalFouls += value
        }
    }
    
    private func updateGameScore(_ statType: StatType, _ value: Int) {
        switch statType {
        case .fieldGoalMade:
            currentGame.homeScore += 2 * value // Assuming home team for now
        case .threePointerMade:
            currentGame.homeScore += 1 * value // Additional point for 3PT
        case .freeThrowMade:
            currentGame.homeScore += 1 * value
        default:
            break
        }
    }
}
