import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var currentPage = 0
    
    var body: some View {
        TabView(selection: $currentPage) {
            // Welcome Page
            OnboardingPageView(
                title: "Welcome to Basketball Analytics",
                subtitle: "Your complete basketball performance tracking platform",
                imageName: "basketball.fill",
                color: .orange
            )
            .tag(0)
            
            // Role-specific page
            if let user = authViewModel.currentUser {
                switch user.role {
                case .player:
                    OnboardingPageView(
                        title: "Track Your Performance",
                        subtitle: "Monitor your stats, view trends, and improve your game",
                        imageName: "chart.line.uptrend.xyaxis",
                        color: .blue
                    )
                    .tag(1)
                    
                case .coach:
                    OnboardingPageView(
                        title: "Analyze Your Team",
                        subtitle: "Compare players, track team performance, and make data-driven decisions",
                        imageName: "person.3.fill",
                        color: .green
                    )
                    .tag(1)
                    
                case .manager:
                    OnboardingPageView(
                        title: "Manage Everything",
                        subtitle: "Input stats, manage rosters, and generate comprehensive reports",
                        imageName: "folder.fill",
                        color: .orange
                    )
                    .tag(1)
                    
                case .admin:
                    OnboardingPageView(
                        title: "Oversee Operations",
                        subtitle: "Manage teams, users, and league-wide statistics",
                        imageName: "crown.fill",
                        color: .red
                    )
                    .tag(1)
                }
            }
            
            // Final page
            OnboardingPageView(
                title: "Ready to Get Started?",
                subtitle: "Let's begin your basketball analytics journey",
                imageName: "checkmark.circle.fill",
                color: .green,
                isLast: true
            )
            .tag(2)
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
}

struct OnboardingPageView: View {
    let title: String
    let subtitle: String
    let imageName: String
    let color: Color
    var isLast: Bool = false
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: imageName)
                .font(.system(size: 100))
                .foregroundColor(color)
            
            VStack(spacing: 16) {
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text(subtitle)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            if isLast {
                Button(action: {
                    authViewModel.showOnboarding = false
                }) {
                    Text("Get Started")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(color)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
}
