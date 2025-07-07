import SwiftUI

struct LiveGameView: View {
    @StateObject private var gameViewModel = LiveGameViewModel()
    @State private var selectedPlayer: Player?
    @State private var showPlayerPicker = false
    @State private var showGameSetup = true
    
    var body: some View {
        NavigationStack {
            if showGameSetup {
                GameSetupView(onGameStart: { homeTeam, awayTeam in
                    gameViewModel.setupGame(homeTeam: homeTeam, awayTeam: awayTeam)
                    showGameSetup = false
                })
            } else {
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
                        Menu {
                            Button("End Game", role: .destructive) {
                                gameViewModel.endGame()
                                showGameSetup = true
                            }
                            
                            Button("Undo Last Action") {
                                gameViewModel.undoLastAction()
                            }
                            .disabled(gameViewModel.statHistory.isEmpty)
                            
                            Button("Reset Game") {
                                gameViewModel.resetGame()
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showPlayerPicker) {
            PlayerPickerView(selectedPlayer: $selectedPlayer)
        }
    }
}

struct GameSetupView: View {
    @State private var homeTeamName = ""
    @State private var awayTeamName = ""
    let onGameStart: (String, String) -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            VStack(spacing: 16) {
                Image(systemName: "basketball.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.orange)
                
                Text("Setup New Game")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Enter team names to start tracking")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Home Team")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    TextField("Enter home team name", text: $homeTeamName)
                        .textFieldStyle(CustomTextFieldStyle())
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Away Team")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    TextField("Enter away team name", text: $awayTeamName)
                        .textFieldStyle(CustomTextFieldStyle())
                }
            }
            
            Button(action: {
                onGameStart(homeTeamName, awayTeamName)
            }) {
                Text("Start Game")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        LinearGradient(
                            colors: [.orange, .red],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .disabled(homeTeamName.isEmpty || awayTeamName.isEmpty)
            
            Spacer()
        }
        .padding(.horizontal, 32)
        .navigationTitle("New Game")
    }
}

struct GameHeaderView: View {
    let game: Game
    
    var body: some View {
        VStack(spacing: 16) {
            // Score Display
            HStack {
                VStack(spacing: 8) {
                    Text(game.homeTeamName)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                    
                    Text("\(game.homeScore)")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.orange)
                }
                .frame(maxWidth: .infinity)
                
                VStack(spacing: 8) {
                    Text("Q\(game.quarter)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text(timeString(from: game.timeRemaining))
                        .font(.title)
                        .fontWeight(.medium)
                        .foregroundColor(game.isLive ? .red : .secondary)
                        .monospacedDigit()
                    
                    if game.isLive {
                        HStack(spacing: 4) {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 8, height: 8)
                            
                            Text("LIVE")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                
                VStack(spacing: 8) {
                    Text(game.awayTeamName)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                    
                    Text("\(game.awayScore)")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.blue)
                }
                .frame(maxWidth: .infinity)
            }
            
            // Quarter Scores
            HStack {
                Text("Quarter Scores:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                HStack(spacing: 8) {
                    ForEach(0..<4) { quarter in
                        VStack(spacing: 2) {
                            Text("Q\(quarter + 1)")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            
                            Text("\(game.quarterScores[quarter][0])-\(game.quarterScores[quarter][1])")
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        .opacity(quarter < game.quarter ? 1.0 : 0.5)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
        )
        .padding(.horizontal)
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
        HStack(spacing: 16) {
            Text("Player:")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Button(action: {
                showPlayerPicker = true
            }) {
                HStack(spacing: 8) {
                    if let player = selectedPlayer {
                        HStack(spacing: 8) {
                            Text("#\(player.jerseyNumber)")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(width: 24, height: 24)
                                .background(Color.orange)
                                .clipShape(Circle())
                            
                            Text(player.name)
                                .fontWeight(.medium)
                        }
                    } else {
                        HStack(spacing: 8) {
                            Image(systemName: "person.circle")
                                .foregroundColor(.secondary)
                            
                            Text("Select Player")
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Image(systemName: "chevron.down")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemGray5))
                )
            }
            .foregroundColor(.primary)
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct StatInputGridView: View {
    let selectedPlayer: Player?
    let onStatUpdate: (UUID, StatType, Int) -> Void
    
    private let statButtons: [(title: String, statType: StatType, color: Color)] = [
        ("2PT Made", .fieldGoalMade, .green),
        ("2PT Miss", .fieldGoalMissed, .red),
        ("3PT Made", .threePointerMade, .blue),
        ("3PT Miss", .threePointerMissed, .orange),
        ("FT Made", .freeThrowMade, .mint),
        ("FT Miss", .freeThrowMissed, .pink),
        ("Rebound", .rebound, .purple),
        ("Assist", .assist, .cyan),
        ("Steal", .steal, .yellow),
        ("Block", .block, .indigo),
        ("Turnover", .turnover, .red),
        ("Foul", .foul, .orange)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                ForEach(Array(statButtons.enumerated()), id: \.offset) { index, button in
                    StatButtonView(
                        title: button.title,
                        color: button.color,
                        isEnabled: selectedPlayer != nil
                    ) {
                        if let player = selectedPlayer {
                            onStatUpdate(player.id, button.statType, 1)
                        }
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
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            action()
            // Haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
        }) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isEnabled ? color : Color.gray)
                        .scaleEffect(isPressed ? 0.95 : 1.0)
                )
        }
        .disabled(!isEnabled)
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

struct GameControlsView: View {
    @ObservedObject var gameViewModel: LiveGameViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            // Primary Controls
            HStack(spacing: 20) {
                Button(action: gameViewModel.startPauseGame) {
                    HStack(spacing: 8) {
                        Image(systemName: gameViewModel.currentGame.isLive ? "pause.fill" : "play.fill")
                            .font(.title2)
                        
                        Text(gameViewModel.currentGame.isLive ? "Pause" : "Start")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(
                        LinearGradient(
                            colors: gameViewModel.currentGame.isLive ? [.orange, .red] : [.green, .mint],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
                }
                
                Button(action: gameViewModel.resetClock) {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.clockwise")
                            .font(.title2)
                        
                        Text("Reset")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.blue)
                    .cornerRadius(12)
                }
            }
            
            // Secondary Controls
            HStack(spacing: 12) {
                Button(action: gameViewModel.nextQuarter) {
                    Text("Next Quarter")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .background(Color.purple)
                        .cornerRadius(8)
                }
                
                Button(action: gameViewModel.timeout) {
                    Text("Timeout")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .background(Color.gray)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
        )
        .padding(.horizontal)
    }
}
