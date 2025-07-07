import SwiftUI
import Charts

struct PlayerDashboardView: View {
    @EnvironmentObject var authService: AuthService
    @State private var selectedTimeframe: TimeFrame = .season
    @State private var showProfile = false
    
    enum TimeFrame: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case season = "Season"
        
        var icon: String {
            switch self {
            case .week: return "calendar"
            case .month: return "calendar.badge.clock"
            case .season: return "calendar.badge.plus"
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Player Header
                    PlayerHeaderCard()
                    
                    // Quick Stats Grid
                    QuickStatsGrid()
                    
                    // Performance Chart
                    PerformanceChartCard(timeframe: selectedTimeframe)
                    
                    // Recent Games
                    RecentGamesCard()
                    
                    // Highlight Videos
                    HighlightVideosCard()
                }
                .padding()
            }
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        ForEach(TimeFrame.allCases, id: \.self) { timeframe in
                            Button(action: { selectedTimeframe = timeframe }) {
                                Label(timeframe.rawValue, systemImage: timeframe.icon)
                            }
                        }
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showProfile = true }) {
                        AsyncImage(url: URL(string: "")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Image(systemName: "person.circle.fill")
                                .foregroundColor(.orange)
                        }
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                    }
                }
            }
        }
        .sheet(isPresented: $showProfile) {
            PlayerProfileView()
        }
    }
}

struct PlayerHeaderCard: View {
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                AsyncImage(url: URL(string: "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                }
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.orange, lineWidth: 3)
                )
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("John Doe")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    HStack {
                        Text("Point Guard")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text("•")
                            .foregroundColor(.secondary)
                        
                        Text("#23")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.orange)
                    }
                    
                    HStack(spacing: 16) {
                        Label("6'2\"", systemImage: "ruler")
                        Label("180 lbs", systemImage: "scalemass")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            // Season Summary
            HStack {
                VStack {
                    Text("15")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                    Text("Games")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack {
                    Text("12-3")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    Text("W-L")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack {
                    Text("18.5")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    Text("PPG")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack {
                    Text("85.2")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.purple)
                    Text("PER")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.top, 8)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
        )
    }
}

struct QuickStatsGrid: View {
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
            StatCard(title: "FG%", value: "45.2%", color: .blue, trend: .up, change: "+2.1%")
            StatCard(title: "3P%", value: "38.7%", color: .green, trend: .up, change: "+1.5%")
            StatCard(title: "FT%", value: "82.4%", color: .orange, trend: .down, change: "-0.8%")
            StatCard(title: "RPG", value: "6.8", color: .purple, trend: .up, change: "+0.3")
            StatCard(title: "APG", value: "4.2", color: .mint, trend: .up, change: "+0.7")
            StatCard(title: "SPG", value: "1.8", color: .pink, trend: .stable, change: "0.0")
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    let trend: TrendDirection
    let change: String
    
    enum TrendDirection {
        case up, down, stable
        
        var icon: String {
            switch self {
            case .up: return "arrow.up.right"
            case .down: return "arrow.down.right"
            case .stable: return "minus"
            }
        }
        
        var color: Color {
            switch self {
            case .up: return .green
            case .down: return .red
            case .stable: return .gray
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                HStack(spacing: 2) {
                    Image(systemName: trend.icon)
                        .font(.caption2)
                        .foregroundColor(trend.color)
                    Text(change)
                        .font(.caption2)
                        .foregroundColor(trend.color)
                }
            }
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
    }
}

struct PerformanceChartCard: View {
    let timeframe: PlayerDashboardView.TimeFrame
    
    var sampleData: [ChartDataPoint] {
        (1...10).map { day in
            ChartDataPoint(
                date: Calendar.current.date(byAdding: .day, value: -day, to: Date()) ?? Date(),
                points: Double.random(in: 12...28),
                fieldGoalPercentage: Double.random(in: 35...55)
            )
        }.reversed()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Performance Trends")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("Points and FG% over \(timeframe.rawValue.lowercased())")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "arrow.up.right.square")
                        .foregroundColor(.orange)
                }
            }
            
            Chart(sampleData) { data in
                LineMark(
                    x: .value("Date", data.date),
                    y: .value("Points", data.points)
                )
                .foregroundStyle(.orange)
                .symbol(Circle())
                
                LineMark(
                    x: .value("Date", data.date),
                    y: .value("FG%", data.fieldGoalPercentage)
                )
                .foregroundStyle(.blue)
                .symbol(Rectangle())
            }
            .frame(height: 200)
            .chartYAxis {
                AxisMarks(position: .leading)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
        )
    }
}

struct ChartDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let points: Double
    let fieldGoalPercentage: Double
}

struct RecentGamesCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Recent Games")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("View All") {
                    // Navigate to all games
                }
                .font(.caption)
                .foregroundColor(.orange)
            }
            
            VStack(spacing: 12) {
                ForEach(0..<3) { index in
                    GameRowCard(
                        opponent: ["Lakers", "Warriors", "Celtics"][index],
                        date: Calendar.current.date(byAdding: .day, value: -index * 3, to: Date()) ?? Date(),
                        result: index == 0 ? "W" : (index == 1 ? "L" : "W"),
                        points: [22, 18, 25][index],
                        rebounds: [8, 6, 9][index],
                        assists: [5, 7, 4][index]
                    )
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
        )
    }
}

struct GameRowCard: View {
    let opponent: String
    let date: Date
    let result: String
    let points: Int
    let rebounds: Int
    let assists: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("vs \(opponent)")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(date, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                Text(result)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 20, height: 20)
                    .background(result == "W" ? Color.green : Color.red)
                    .clipShape(Circle())
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(points) PTS")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    Text("\(rebounds)R • \(assists)A")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

struct HighlightVideosCard: View {
    var body: some View {
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
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(0..<3) { index in
                        VideoThumbnailCard(
                            title: ["Game Winner vs Lakers", "Crossover Highlights", "Defensive Plays"][index],
                            duration: ["0:45", "1:23", "2:10"][index]
                        )
                    }
                }
                .padding(.horizontal, 4)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
        )
    }
}

struct VideoThumbnailCard: View {
    let title: String
    let duration: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.black.opacity(0.1))
                    .frame(width: 120, height: 80)
                
                Image(systemName: "play.circle.fill")
                    .font(.title)
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
                .padding(6)
            }
            
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .lineLimit(2)
                .frame(width: 120, alignment: .leading)
        }
    }
}
