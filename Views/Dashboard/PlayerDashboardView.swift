import SwiftUI
import Charts

struct PlayerDashboardView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var selectedTimeframe: TimeFrame = .season
    
    enum TimeFrame: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case season = "Season"
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    PlayerHeaderView()
                    
                    // Quick Stats
                    QuickStatsView()
                    
                    // Performance Chart
                    PerformanceChartView(timeframe: selectedTimeframe)
                    
                    // Recent Games
                    RecentGamesView()
                }
                .padding()
            }
            .navigationTitle("Dashboard")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        ForEach(TimeFrame.allCases, id: \.self) { timeframe in
                            Button(timeframe.rawValue) {
                                selectedTimeframe = timeframe
                            }
                        }
                    } label: {
                        Image(systemName: "calendar")
                    }
                }
            }
        }
    }
}

struct PlayerHeaderView: View {
    var body: some View {
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
            
            VStack(alignment: .leading, spacing: 4) {
                Text("John Doe")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Point Guard • #23")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack {
                    Label("6'2\"", systemImage: "ruler")
                    Label("180 lbs", systemImage: "scalemass")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct QuickStatsView: View {
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
            StatCardView(title: "PPG", value: "18.5", color: .orange)
            StatCardView(title: "FG%", value: "45.2%", color: .blue)
            StatCardView(title: "RPG", value: "6.8", color: .green)
            StatCardView(title: "APG", value: "4.2", color: .purple)
        }
    }
}

struct StatCardView: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct PerformanceChartView: View {
    let timeframe: PlayerDashboardView.TimeFrame
    
    var sampleData: [ChartData] {
        (1...10).map { day in
            ChartData(date: Calendar.current.date(byAdding: .day, value: -day, to: Date()) ?? Date(),
                     points: Double.random(in: 10...25))
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Points Per Game - \(timeframe.rawValue)")
                .font(.headline)
            
            Chart(sampleData) { data in
                LineMark(
                    x: .value("Date", data.date),
                    y: .value("Points", data.points)
                )
                .foregroundStyle(.orange)
                .symbol(Circle())
            }
            .frame(height: 200)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct ChartData: Identifiable {
    let id = UUID()
    let date: Date
    let points: Double
}

struct RecentGamesView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Games")
                .font(.headline)
            
            ForEach(0..<3) { _ in
                GameRowView()
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct GameRowView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("vs Lakers")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text("Dec 15, 2023")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("22 PTS")
                    .font(.subheadline)
                    .fontWeight(.bold)
                
                Text("8 REB • 5 AST")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}
