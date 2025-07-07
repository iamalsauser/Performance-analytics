import SwiftUI
import Charts

struct PlayerProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Profile Header
                ProfileHeaderView()
                
                // Tab Selection
                Picker("Profile Sections", selection: $selectedTab) {
                    Text("Stats").tag(0)
                    Text("Games").tag(1)
                    Text("Videos").tag(2)
                    Text("Bio").tag(3)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // Tab Content
                TabView(selection: $selectedTab) {
                    StatsTabView()
                        .tag(0)
                    
                    GamesTabView()
                        .tag(1)
                    
                    VideosTabView()
                        .tag(2)
                    
                    BioTabView()
                        .tag(3)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .navigationTitle("Player Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button("Export PDF") {
                            // Export functionality
                        }
                        
                        Button("Share Profile") {
                            // Share functionality
                        }
                        
                        Button("Edit Profile") {
                            // Edit functionality
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
        }
    }
}

struct ProfileHeaderView: View {
    var body: some View {
        VStack(spacing: 16) {
            // Profile Image and Basic Info
            HStack(spacing: 20) {
                AsyncImage(url: URL(string: "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.gray)
                }
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [.orange, .red],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 4
                        )
                )
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("John Doe")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Point Guard • #23")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 16) {
                        Label("6'2\"", systemImage: "ruler")
                        Label("180 lbs", systemImage: "scalemass")
                        Label("22 yrs", systemImage: "calendar")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            // Quick Stats
            HStack {
                StatPillView(title: "PPG", value: "18.5", color: .orange)
                StatPillView(title: "RPG", value: "6.8", color: .blue)
                StatPillView(title: "APG", value: "4.2", color: .green)
                StatPillView(title: "FG%", value: "45.2", color: .purple)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
        )
        .padding()
    }
}

struct StatPillView: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemBackground))
        )
    }
}

struct StatsTabView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Season Averages
                VStack(alignment: .leading, spacing: 16) {
                    Text("Season Averages")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                        DetailedStatCard(title: "Points", value: "18.5", subtitle: "per game", color: .orange)
                        DetailedStatCard(title: "Rebounds", value: "6.8", subtitle: "per game", color: .blue)
                        DetailedStatCard(title: "Assists", value: "4.2", subtitle: "per game", color: .green)
                        DetailedStatCard(title: "Steals", value: "1.8", subtitle: "per game", color: .purple)
                        DetailedStatCard(title: "Field Goal %", value: "45.2%", subtitle: "shooting", color: .red)
                        DetailedStatCard(title: "3-Point %", value: "38.7%", subtitle: "from three", color: .mint)
                    }
                }
                
                // Performance Chart
                VStack(alignment: .leading, spacing: 12) {
                    Text("Performance Trends")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Chart(sampleChartData) { data in
                        LineMark(
                            x: .value("Game", data.game),
                            y: .value("Points", data.points)
                        )
                        .foregroundStyle(.orange)
                        .symbol(Circle())
                    }
                    .frame(height: 200)
                    .chartYAxis {
                        AxisMarks(position: .leading)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                )
            }
            .padding()
        }
    }
    
    private var sampleChartData: [GamePerformance] {
        (1...10).map { game in
            GamePerformance(game: game, points: Double.random(in: 12...28))
        }
    }
}

struct DetailedStatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(subtitle)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
    }
}

struct GamePerformance: Identifiable {
    let id = UUID()
    let game: Int
    let points: Double
}

struct GamesTabView: View {
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(0..<10) { index in
                    DetailedGameCard(
                        opponent: ["Lakers", "Warriors", "Celtics", "Heat", "Nets"][index % 5],
                        date: Calendar.current.date(byAdding: .day, value: -index * 3, to: Date()) ?? Date(),
                        result: index % 3 == 0 ? "W" : "L",
                        score: "\(Int.random(in: 95...120))-\(Int.random(in: 90...115))",
                        stats: PlayerGameStats(
                            points: Int.random(in: 12...28),
                            rebounds: Int.random(in: 4...12),
                            assists: Int.random(in: 2...8),
                            steals: Int.random(in: 0...4),
                            blocks: Int.random(in: 0...3),
                            fieldGoalPercentage: Double.random(in: 35...60)
                        )
                    )
                }
            }
            .padding()
        }
    }
}

struct DetailedGameCard: View {
    let opponent: String
    let date: Date
    let result: String
    let score: String
    let stats: PlayerGameStats
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Game Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("vs \(opponent)")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(date, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(result)
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 24, height: 24)
                            .background(result == "W" ? Color.green : Color.red)
                            .clipShape(Circle())
                        
                        Text(score)
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                }
            }
            
            // Player Stats
            HStack {
                StatBubble(value: "\(stats.points)", label: "PTS", color: .orange)
                StatBubble(value: "\(stats.rebounds)", label: "REB", color: .blue)
                StatBubble(value: "\(stats.assists)", label: "AST", color: .green)
                StatBubble(value: "\(stats.steals)", label: "STL", color: .purple)
                StatBubble(value: "\(stats.blocks)", label: "BLK", color: .red)
                StatBubble(value: String(format: "%.1f%%", stats.fieldGoalPercentage), label: "FG%", color: .mint)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
}

struct StatBubble: View {
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct PlayerGameStats {
    let points: Int
    let rebounds: Int
    let assists: Int
    let steals: Int
    let blocks: Int
    let fieldGoalPercentage: Double
}

struct VideosTabView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Highlight Videos")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.orange)
                            .font(.title2)
                    }
                }
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                    ForEach(0..<6) { index in
                        VideoCard(
                            title: [
                                "Game Winner vs Lakers",
                                "Crossover Highlights",
                                "Defensive Plays",
                                "Three-Point Shooting",
                                "Fast Break Dunks",
                                "Clutch Moments"
                            ][index],
                            duration: ["0:45", "1:23", "2:10", "1:05", "0:38", "1:47"][index],
                            views: Int.random(in: 100...5000)
                        )
                    }
                }
            }
            .padding()
        }
    }
}

struct VideoCard: View {
    let title: String
    let duration: String
    let views: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            colors: [.black.opacity(0.3), .black.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 100)
                
                Image(systemName: "play.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text(duration)
                            .font(.caption2)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(4)
                    }
                }
                .padding(8)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(2)
                
                Text("\(views) views")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct BioTabView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Personal Information
                VStack(alignment: .leading, spacing: 16) {
                    Text("Personal Information")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    VStack(spacing: 12) {
                        InfoRow(label: "Full Name", value: "John Michael Doe")
                        InfoRow(label: "Date of Birth", value: "March 15, 2001")
                        InfoRow(label: "Age", value: "22 years old")
                        InfoRow(label: "Height", value: "6'2\" (188 cm)")
                        InfoRow(label: "Weight", value: "180 lbs (82 kg)")
                        InfoRow(label: "Wingspan", value: "6'4\" (193 cm)")
                        InfoRow(label: "Position", value: "Point Guard")
                        InfoRow(label: "Jersey Number", value: "#23")
                        InfoRow(label: "Dominant Hand", value: "Right")
                    }
                }
                
                // Career Information
                VStack(alignment: .leading, spacing: 16) {
                    Text("Career Information")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    VStack(spacing: 12) {
                        InfoRow(label: "Team", value: "Lakers")
                        InfoRow(label: "Years Pro", value: "3 years")
                        InfoRow(label: "College", value: "UCLA")
                        InfoRow(label: "Draft Year", value: "2020")
                        InfoRow(label: "Career High", value: "35 points")
                    }
                }
                
                // Contact Information
                VStack(alignment: .leading, spacing: 16) {
                    Text("Contact Information")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    VStack(spacing: 12) {
                        InfoRow(label: "Email", value: "john.doe@email.com")
                        InfoRow(label: "Phone", value: "+1 (555) 123-4567")
                        InfoRow(label: "Agent", value: "Sports Management Inc.")
                    }
                }
            }
            .padding()
        }
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(width: 120, alignment: .leading)
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}
