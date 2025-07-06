import SwiftUI

struct PlayerPickerView: View {
    @Binding var selectedPlayer: Player?
    @Environment(\.dismiss) private var dismiss
    
    // Sample players - in real app, this would come from a data source
    private let samplePlayers = [
        Player(name: "John Doe", jerseyNumber: 23, position: .pointGuard, height: "6'2\"", weight: "180", dateOfBirth: Date(), dominantHand: .right, teamId: "team1"),
        Player(name: "Mike Johnson", jerseyNumber: 15, position: .shootingGuard, height: "6'4\"", weight: "190", dateOfBirth: Date(), dominantHand: .right, teamId: "team1"),
        Player(name: "Chris Wilson", jerseyNumber: 32, position: .center, height: "6'10\"", weight: "240", dateOfBirth: Date(), dominantHand: .left, teamId: "team1"),
        Player(name: "David Brown", jerseyNumber: 8, position: .smallForward, height: "6'6\"", weight: "210", dateOfBirth: Date(), dominantHand: .right, teamId: "team1"),
        Player(name: "Alex Davis", jerseyNumber: 44, position: .powerForward, height: "6'8\"", weight: "225", dateOfBirth: Date(), dominantHand: .right, teamId: "team1")
    ]
    
    var body: some View {
        NavigationStack {
            List(samplePlayers) { player in
                PlayerRowView(
                    player: player,
                    isSelected: selectedPlayer?.id == player.id
                ) {
                    selectedPlayer = player
                    dismiss()
                }
            }
            .navigationTitle("Select Player")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
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
            HStack {
                // Jersey Number
                Text("#\(player.jerseyNumber)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(Color.orange)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(player.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(player.position.rawValue)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.title2)
                }
            }
            .padding(.vertical, 4)
        }
    }
}
