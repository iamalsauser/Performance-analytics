import SwiftUI

struct ContentView: View {
    @StateObject private var authService = AuthService()
    
    var body: some View {
        Group {
            if authService.isAuthenticated {
                if authService.showOnboarding {
                    OnboardingView()
                        .environmentObject(authService)
                } else {
                    MainTabView()
                        .environmentObject(authService)
                }
            } else {
                LoginView()
                    .environmentObject(authService)
            }
        }
    }
}

struct MainTabView: View {
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        TabView {
            // Dashboard tab - role-specific content
            Group {
                switch authService.currentUser?.role {
                case .player:
                    PlayerDashboardView()
                case .coach:
                    CoachDashboardView()
                case .manager:
                    ManagerDashboardView()
                case .none:
                    PlayerDashboardView() // Default fallback
                }
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Dashboard")
            }
            
            // Live Game tab (for managers and coaches)
            if authService.currentUser?.role == .manager || authService.currentUser?.role == .coach {
                LiveGameView()
                    .tabItem {
                        Image(systemName: "play.circle.fill")
                        Text("Live Game")
                    }
            }
            
            // Players tab
            PlayersListView()
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("Players")
                }
            
            // Stats tab
            StatsView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Analytics")
                }
            
            // Profile tab
            ProfileView()
                .tabItem {
                    Image(systemName: "person.circle.fill")
                    Text("Profile")
                }
        }
        .tint(.orange)
    }
}

// Placeholder views for other dashboards and tabs
struct CoachDashboardView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Coach Dashboard")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    // Team Performance Overview
                    TeamPerformanceCard()
                    
                    // Player Comparison
                    PlayerComparisonCard()
                    
                    // Recent Games
                    RecentGamesOverviewCard()
                }
                .padding()
            }
            .navigationTitle("Coach Dashboard")
        }
    }
}

struct ManagerDashboardView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Manager Dashboard")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    // Quick Actions
                    QuickActionsCard()
                    
                    // Team Management
                    TeamManagementCard()
                    
                    // Recent Activity
                    RecentActivityCard()
                }
                .padding()
            }
            .navigationTitle("Manager Dashboard")
        }
    }
}

struct PlayersListView: View {
    var body: some View {
        NavigationStack {
            Text("Players List View")
                .navigationTitle("Players")
        }
    }
}

struct StatsView: View {
    var body: some View {
        NavigationStack {
            Text("Analytics View")
                .navigationTitle("Analytics")
        }
    }
}

struct ProfileView: View {
    @EnvironmentObject var authService: AuthService
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                if let user = authService.currentUser {
                    VStack(spacing: 20) {
                        // Profile Image
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 100))
                            .foregroundColor(.gray)
                        
                        VStack(spacing: 8) {
                            Text(user.name)
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text(user.role.rawValue)
                                .font(.subheadline)
                                .foregroundColor(user.role.color)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(user.role.color.opacity(0.1))
                                .cornerRadius(20)
                        }
                        
                        Text(user.email)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                VStack(spacing: 16) {
                    ProfileMenuButton(title: "Edit Profile", icon: "person.crop.circle", action: {})
                    ProfileMenuButton(title: "Settings", icon: "gear", action: {})
                    ProfileMenuButton(title: "Help & Support", icon: "questionmark.circle", action: {})
                    ProfileMenuButton(title: "About", icon: "info.circle", action: {})
                }
                
                Button("Sign Out") {
                    authService.signOut()
                }
                .foregroundColor(.red)
                .font(.headline)
                .padding()
                
                Spacer()
            }
            .padding()
            .navigationTitle("Profile")
        }
    }
}

struct ProfileMenuButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.orange)
                    .frame(width: 24)
                
                Text(title)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
            )
        }
    }
}

// Placeholder card views
struct TeamPerformanceCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Team Performance")
                .font(.headline)
                .fontWeight(.semibold)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Win Rate")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("75%")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Avg Points")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("98.5")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
}

struct PlayerComparisonCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Top Performers")
                .font(.headline)
                .fontWeight(.semibold)
            
            ForEach(0..<3) { index in
                HStack {
                    Text("#\(index + 1)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                        .background(Color.orange)
                        .clipShape(Circle())
                    
                    Text("Player \(index + 1)")
                        .font(.subheadline)
                    
                    Spacer()
                    
                    Text("\(20 - index * 2) PPG")
                        .font(.caption)
                        .fontWeight(.medium)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
}

struct RecentGamesOverviewCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Games")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 8) {
                GameResultRow(opponent: "Lakers", result: "W", score: "112-108")
                GameResultRow(opponent: "Warriors", result: "L", score: "98-105")
                GameResultRow(opponent: "Celtics", result: "W", score: "120-115")
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
}

struct GameResultRow: View {
    let opponent: String
    let result: String
    let score: String
    
    var body: some View {
        HStack {
            Text("vs \(opponent)")
                .font(.subheadline)
            
            Spacer()
            
            Text(result)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 20, height: 20)
                .background(result == "W" ? Color.green : Color.red)
                .clipShape(Circle())
            
            Text(score)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct QuickActionsCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ActionButton(title: "Start Live Game", icon: "play.circle.fill", color: .green)
                ActionButton(title: "Add Player", icon: "person.badge.plus", color: .blue)
                ActionButton(title: "Enter Stats", icon: "square.and.pencil", color: .orange)
                ActionButton(title: "Generate Report", icon: "doc.text", color: .purple)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
}

struct ActionButton: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        Button(action: {}) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(8)
        }
    }
}

struct TeamManagementCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Team Management")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text("15 Active Players")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Button("Manage Roster") {
                // Navigate to roster management
            }
            .foregroundColor(.orange)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
}

struct RecentActivityCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Activity")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Game vs Lakers - Stats entered")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("Player John Doe - Profile updated")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("Training session - Video uploaded")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
}
