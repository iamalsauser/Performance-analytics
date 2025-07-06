import SwiftUI

struct LiveGameView: View {
    @StateObject private var gameViewModel = LiveGameViewModel()
    @State private var selectedPlayer: Player?
    @State private var showPlayerPicker = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Game Header
                GameHeaderView(game: gameViewModel.currentGame)
                
                // Player Selection
                PlayerSelectionView(
                    selectedPlayer: $selectedPlayer,
                    showPlayerPicker: $showPlayerPicker
                )
                
                // Stat Input Grid
                StatInputGridView(
                    selectedPlayer: selectedPlayer,
                    onStatUpdate: gameViewModel.updateStat
                )
                
                // Game Controls
                GameControlsView(gameViewModel: gameViewModel)
            }
            .navigationTitle("Live Game")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("End Game") {
                        gameViewModel.endGame()
                    }
                    .foregroundColor(.red)
                }
            }
        }
        .sheet(isPresented: $showPlayerPicker) {
            PlayerPickerView(selectedPlayer: $selectedPlayer)
        }
    }
}

struct GameHeaderView: View {
    let game: Game
    
    var body: some View {
        VStack(spacing: 12) {
            // Score
            HStack {
                VStack {
                    Text("HOME")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(game.homeScore)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                
                Spacer()
                
                VStack(spacing: 4) {
                    Text("Q\(game.quarter)")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Text(timeString(from: game.timeRemaining))
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.orange)
                }
                
                Spacer()
                
                VStack {
                    Text("AWAY")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(game.awayScore)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
            }
            .padding(.horizontal, 40)
            
            // Game Status
            if game.isLive {
                Text("LIVE")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color.red)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(.systemGray6))
    }
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct PlayerSelectionView: View {
    @Binding var selectedPlayer: Player?
    @Binding var showPlayerPicker: Bool
    
    var body: some View {
        HStack {
            Text("Selected Player:")
                .font(.headline)
            
            Button(action: {
                showPlayerPicker = true
            }) {
                HStack {
                    if let player = selectedPlayer {
                        Text("#\(player.jerseyNumber) \(player.name)")
                            .fontWeight(.medium)
                    } else {
                        Text("Select Player")
                            .foregroundColor(.secondary)
                    }
                    
                    Image(systemName: "chevron.down")
                        .font(.caption)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color(.systemGray5))
                .cornerRadius(8)
            }
            .foregroundColor(.primary)
            
            Spacer()
        }
        .padding()
    }
}

struct StatInputGridView: View {
    let selectedPlayer: Player?
    let onStatUpdate: (UUID, StatType, Int) -> Void
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                // Shooting Stats
                StatButtonView(
                    title: "2PT Made",
                    color: .green,
                    isEnabled: selectedPlayer != nil
                ) {
                    if let player = selectedPlayer {
                        onStatUpdate(player.id, .fieldGoalMade, 1)
                    }
                }
                
                StatButtonView(
                    title: "2PT Miss",
                    color: .red,
                    isEnabled: selectedPlayer != nil
                ) {
                    if let player = selectedPlayer {
                        onStatUpdate(player.id, .fieldGoalMissed, 1)
                    }
                }
                
                StatButtonView(
                    title: "3PT Made",
                    color: .blue,
                    isEnabled: selectedPlayer != nil
                ) {
                    if let player = selectedPlayer {
                        onStatUpdate(player.id, .threePointerMade, 1)
                    }
                }
                
                StatButtonView(
                    title: "3PT Miss",
                    color: .orange,
                    isEnabled: selectedPlayer != nil
                ) {
                    if let player = selectedPlayer {
                        onStatUpdate(player.id, .threePointerMissed, 1)
                    }
                }
                
                StatButtonView(
                    title: "FT Made",
                    color: .green,
                    isEnabled: selectedPlayer != nil
                ) {
                    if let player = selectedPlayer {
                        onStatUpdate(player.id, .freeThrowMade, 1)
                    }
                }
                
                StatButtonView(
                    title: "FT Miss",
                    color: .red,
                    isEnabled: selectedPlayer != nil
                ) {
                    if let player = selectedPlayer {
                        onStatUpdate(player.id, .freeThrowMissed, 1)
                    }
                }
                
                StatButtonView(
                    title: "Rebound",
                    color: .purple,
                    isEnabled: selectedPlayer != nil
                ) {
                    if let player = selectedPlayer {
                        onStatUpdate(player.id, .rebound, 1)
                    }
                }
                
                StatButtonView(
                    title: "Assist",
                    color: .cyan,
                    isEnabled: selectedPlayer != nil
                ) {
                    if let player = selectedPlayer {
                        onStatUpdate(player.id, .assist, 1)
                    }
                }
                
                StatButtonView(
                    title: "Steal",
                    color: .yellow,
                    isEnabled: selectedPlayer != nil
                ) {
                    if let player = selectedPlayer {
                        onStatUpdate(player.id, .steal, 1)
                    }
                }
                
                StatButtonView(
                    title: "Block",
                    color: .indigo,
                    isEnabled: selectedPlayer != nil
                ) {
                    if let player = selectedPlayer {
                        onStatUpdate(player.id, .block, 1)
                    }
                }
                
                StatButtonView(
                    title: "Turnover",
                    color: .red,
                    isEnabled: selectedPlayer != nil
                ) {
                    if let player = selectedPlayer {
                        onStatUpdate(player.id, .turnover, 1)
                    }
                }
                
                StatButtonView(
                    title: "Foul",
                    color: .orange,
                    isEnabled: selectedPlayer != nil
                ) {
                    if let player = selectedPlayer {
                        onStatUpdate(player.id, .foul, 1)
                    }
                }
            }
            .padding()
        }
    }
}

struct StatButtonView: View {
    let title: String
    let color: Color
    let isEnabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(isEnabled ? color : Color.gray)
                .cornerRadius(12)
        }
        .disabled(!isEnabled)
    }
}

struct GameControlsView: View {
    @ObservedObject var gameViewModel: LiveGameViewModel
    
    var body: some View {
        HStack(spacing: 20) {
            Button(action: gameViewModel.startPauseGame) {
                Image(systemName: gameViewModel.currentGame.isLive ? "pause.fill" : "play.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 60, height: 60)
                    .background(gameViewModel.currentGame.isLive ? Color.orange : Color.green)
                    .clipShape(Circle())
            }
            
            Button(action: gameViewModel.resetClock) {
                Image(systemName: "arrow.clockwise")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 60, height: 60)
                    .background(Color.blue)
                    .clipShape(Circle())
            }
            
            Button(action: gameViewModel.nextQuarter) {
                Text("Next Q")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 80, height: 60)
                    .background(Color.purple)
                    .cornerRadius(12)
            }
        }
        .padding()
        .background(Color(.systemGray6))
    }
}
