import SwiftUI

struct PlayerPickerView: View {
    @Binding var selectedPlayer: Player?
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    
    // Sample players - in real app, this would come from a data source
    private let samplePlayers = [
        Player(name: "John Doe", jerseyNumber: 23, position: .pointGuard, height: "6'2\"", weight: "180", age: 22, dateOfBirth: Date(), teamId: "team1"),
        Player(name: "Mike Johnson", jerseyNumber: 15, position: .shootingGuard, height: "6'4\"", weight: "190", age: 24, dateOfBirth: Date(), teamId: "team1"),
        Player(name: "Chris Wilson", jerseyNumber: 32, position: .center, height: "6'10\"", weight: "240", age: 26, dateOfBirth: Date(), teamId: "team1"),
        Player(name: "David Brown", jerseyNumber: 8, position: .smallForward, height: "6'6\"", weight: "210", age: 23, dateOfBirth: Date(), teamId: "team1"),
        Player(name: "Alex Davis", jerseyNumber: 44, position: .powerForward, height: "6'8\"", weight: "225", age: 25, dateOfBirth: Date(), teamId: "team1"),
        Player(name: "Ryan Miller", jerseyNumber: 11, position: .pointGuard, height: "6'1\"", weight: "175", age: 21, dateOfBirth: Date(), teamId: "team1"),
        Player(name: "Kevin Lee", jerseyNumber: 7, position: .shootingGuard, height: "6'3\"", weight: "185", age: 27, dateOfBirth: Date(), teamId: "team1"),
        Player(name: "Marcus Thompson", jerseyNumber: 21, position: .smallForward, height: "6'7\"", weight: "215", age: 24, dateOfBirth: Date(), teamId: "team1")
    ]
    
    private var filteredPlayers: [Player] {
        if searchText.isEmpty {
            return samplePlayers
        } else {
            return samplePlayers.filter { player in
                player.name.localizedCaseInsensitiveContains(searchText) ||
                "\(player.jerseyNumber)".contains(searchText) ||
                player.position.rawValue.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    
                    TextField("Search players...", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding()
                
                // Players List
                List(filteredPlayers) { player in
                    PlayerRowView(
                        player: player,
                        isSelected: selectedPlayer?.id == player.id
                    ) {
                        selectedPlayer = player
                        dismiss()
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Select Player")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Clear") {
                        selectedPlayer = nil
                        dismiss()
                    }
                    .disabled(selectedPlayer == nil)
                }
            }
        }
    }
}

struct PlayerRowView: View {
    let player: Player
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Jersey Number
                Text("#\(player.jerseyNumber)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(
                        LinearGradient(
                            colors: [.orange, .red],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(player.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    HStack {
                        Text(player.position.abbreviation)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.blue)
                            .cornerRadius(4)
                        
                        Text("\(player.height) • \(player.weight)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.title2)
                }
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
