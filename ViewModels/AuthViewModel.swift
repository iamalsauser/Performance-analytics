import Foundation
import SwiftUI

@MainActor
class AuthViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var showOnboarding = false
    
    init() {
        checkAuthStatus()
    }
    
    func signIn(email: String, password: String) async {
        isLoading = true
        errorMessage = ""
        
        // Simulate API call
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Mock authentication - replace with real authentication
        if email.contains("@") && password.count >= 6 {
            let role: UserRole = email.contains("coach") ? .coach : 
                                email.contains("manager") ? .manager : .player
            
            currentUser = User(email: email, name: "John Doe", role: role)
            isAuthenticated = true
            showOnboarding = true
        } else {
            errorMessage = "Invalid credentials"
        }
        
        isLoading = false
    }
    
    func signUp(email: String, password: String, name: String, role: UserRole) async {
        isLoading = true
        errorMessage = ""
        
        // Simulate API call
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        currentUser = User(email: email, name: name, role: role)
        isAuthenticated = true
        showOnboarding = true
        isLoading = false
    }
    
    func signOut() {
        currentUser = nil
        isAuthenticated = false
        showOnboarding = false
    }
    
    private func checkAuthStatus() {
        // Check for stored authentication state
        // This would typically check keychain or UserDefaults
    }
}
