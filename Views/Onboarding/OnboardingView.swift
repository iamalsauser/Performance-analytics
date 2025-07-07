import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var authService: AuthService
    @State private var currentPage = 0
    
    private let pages = OnboardingPage.allPages
    
    var body: some View {
        VStack(spacing: 0) {
            // Page Content
            TabView(selection: $currentPage) {
                ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                    OnboardingPageView(page: page, isLast: index == pages.count - 1)
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            // Bottom Section
            VStack(spacing: 20) {
                // Page Indicator
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? Color.orange : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .scaleEffect(index == currentPage ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                
                // Navigation Buttons
                HStack(spacing: 16) {
                    if currentPage > 0 {
                        Button("Back") {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentPage -= 1
                            }
                        }
                        .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    if currentPage < pages.count - 1 {
                        Button("Next") {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentPage += 1
                            }
                        }
                        .fontWeight(.semibold)
                        .foregroundColor(.orange)
                    } else {
                        Button("Get Started") {
                            authService.completeOnboarding()
                        }
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 120, height: 44)
                        .background(
                            LinearGradient(
                                colors: [.orange, .red],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(22)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 32)
            }
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    let isLast: Bool
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Icon
            Image(systemName: page.icon)
                .font(.system(size: 100))
                .foregroundStyle(
                    LinearGradient(
                        colors: page.colors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            // Content
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text(page.subtitle)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
    }
}

struct OnboardingPage {
    let title: String
    let subtitle: String
    let icon: String
    let colors: [Color]
    
    static let allPages = [
        OnboardingPage(
            title: "Welcome to Athlinix",
            subtitle: "Your complete basketball analytics platform for tracking performance and improving your game",
            icon: "basketball.fill",
            colors: [.orange, .red]
        ),
        OnboardingPage(
            title: "Track Performance",
            subtitle: "Monitor your stats, analyze trends, and see your improvement over time with detailed analytics",
            icon: "chart.line.uptrend.xyaxis",
            colors: [.blue, .purple]
        ),
        OnboardingPage(
            title: "Real-Time Stats",
            subtitle: "Enter game statistics in real-time or after matches with our intuitive stat tracking system",
            icon: "stopwatch.fill",
            colors: [.green, .mint]
        ),
        OnboardingPage(
            title: "Team Collaboration",
            subtitle: "Coaches and managers can analyze team performance and make data-driven decisions",
            icon: "person.3.fill",
            colors: [.purple, .pink]
        )
    ]
}
