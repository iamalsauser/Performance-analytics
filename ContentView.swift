import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                if authViewModel.showOnboarding {
                    OnboardingView()
                        .environmentObject(authViewModel)
                } else {
                    MainTabView()
                        .environmentObject(authViewModel)
                }
            } else {
                LoginView()
                    .environmentObject(authViewModel)
            }
        }
    }
}

struct MainTabView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        TabView {
            // Dashboard tab - role-specific content
            Group {
                switch authViewModel.currentUser?.role {
                case .player:
                    PlayerDashboardView()
                case .coach:
                    CoachDashboardView()
                case .manager:
                    ManagerDashboardView()
                case .admin:
                    AdminDashboardView()
                case .none:
                    PlayerDashboardView() // Default fallback
                }
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Dashboard")
            }
            
            // Live Game tab (for managers and coaches)
            if authViewModel.currentUser?.role == .manager || authViewModel.currentUser?.role == .coach {
                LiveGameView()
                    .tabItem {
                        Image(systemName: "play.circle.fill")
                        Text("Live Game")
                    }
            }
            
            // Players tab
            PlayersView()
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("Players")
                }
            
            // Stats tab
            StatsView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Stats")
                }
            
            // Profile tab
            ProfileView()
                .tabItem {
                    Image(systemName: "person.circle.fill")
                    Text("Profile")
                }
        }
        .accentColor(.orange)
    }
}

// Placeholder views for other dashboards
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
                    
                    // Fatigue Insights
                    FatigueInsightsCard()
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
                    
                    // Roster Management
                    RosterManagementCard()
                    
                    // Recent Uploads
                    RecentUploadsCard()
                }
                .padding()
            }
            .navigationTitle("Manager Dashboard")
        }
    }
}

struct AdminDashboardView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Admin Dashboard")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    // System Overview
                    SystemOverviewCard()
                    
                    // User Management
                    UserManagementCard()
                    
                    // League Statistics
                    LeagueStatsCard()
                }
                .padding()
            }
            .navigationTitle("Admin Dashboard")
        }
    }
}

// Placeholder card views
struct TeamPerformanceCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Team Performance")
                .font(.headline)
            
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
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct PlayerComparisonCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Top Performers")
                .font(.headline)
            
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
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct FatigueInsightsCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Fatigue Insights")
                .font(.headline)
            
            Text("3 players showing signs of fatigue")
                .font(.subheadline)
                .foregroundColor(.orange)
            
            Text("Consider rotation adjustments")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct QuickActionsCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.headline)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ActionButton(title: "Start Live Game", icon: "play.circle.fill", color: .green)
                ActionButton(title: "Add Player", icon: "person.badge.plus", color: .blue)
                ActionButton(title: "Upload Stats", icon: "square.and.arrow.up", color: .orange)
                ActionButton(title: "Generate Report", icon: "doc.text", color: .purple)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
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

struct RosterManagementCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Roster Management")
                .font(.headline)
            
            Text("15 Active Players")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Button("Manage Roster") {
                // Navigate to roster management
            }
            .foregroundColor(.orange)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct RecentUploadsCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Uploads")
                .font(.headline)
            
            Text("Game vs Lakers - Stats uploaded")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text("Training video - Processed")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct SystemOverviewCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("System Overview")
                .font(.headline)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Total Users")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("1,247")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Active Teams")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("89")
                        .font(.title2)
                        .fontWeight(.bold)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct UserManagementCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("User Management")
                .font(.headline)
            
            Text("5 pending approvals")
                .font(.subheadline)
                .foregroundColor(.orange)
            
            Button("Review Users") {
                // Navigate to user management
            }
            .foregroundColor(.orange)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct LeagueStatsCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("League Statistics")
                .font(.headline)
            
            Text("Season: 2023-24")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("Games Played: 1,456")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// Placeholder views for other tabs
struct PlayersView: View {
    var body: some View {
        NavigationStack {
            Text("Players View")
                .navigationTitle("Players")
        }
    }
}

struct StatsView: View {
    var body: some View {
        NavigationStack {
            Text("Stats View")
                .navigationTitle("Statistics")
        }
    }
}

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if let user = authViewModel.currentUser {
                    VStack(spacing: 16) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 100))
                            .foregroundColor(.gray)
                        
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
                }
                
                Button("Sign Out") {
                    authViewModel.signOut()
                }
                .foregroundColor(.red)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Profile")
        }
    }
}
