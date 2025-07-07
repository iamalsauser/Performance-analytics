import Foundation
import SwiftUI

@MainActor
class AuthService: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var showOnboarding = false
    
    private let userDefaultsKey = "athlinix_current_user"
    
    init() {
        loadUserFromStorage()
    }
    
    func signIn(email: String, password: String) async {
        isLoading = true
        errorMessage = ""
        
        // Simulate API call
        try? await Task.sleep(nanoseconds: 1_500_000_000)
        
        // Mock authentication - replace with real authentication
        if email.contains("@") && password.count >= 6 {
            let role: UserRole = email.contains("coach") ? .coach : 
                                email.contains("manager") ? .manager : .player
            
            let user = User(email: email, name: extractNameFromEmail(email), role: role)
            currentUser = user
            isAuthenticated = true
            showOnboarding = user.isFirstLogin
            saveUserToStorage(user)
        } else {
            errorMessage = "Invalid email or password"
        }
        
        isLoading = false
    }
    
    func signUp(email: String, password: String, name: String, role: UserRole) async {
        isLoading = true
        errorMessage = ""
        
        // Simulate API call
        try? await Task.sleep(nanoseconds: 1_500_000_000)
        
        let user = User(email: email, name: name, role: role, isFirstLogin: true)
        currentUser = user
        isAuthenticated = true
        showOnboarding = true
        saveUserToStorage(user)
        isLoading = false
    }
    
    func signOut() {
        currentUser = nil
        isAuthenticated = false
        showOnboarding = false
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
    }
    
    func completeOnboarding() {
        showOnboarding = false
        if var user = currentUser {
            user.isFirstLogin = false
            currentUser = user
            saveUserToStorage(user)
        }
    }
    
    private func loadUserFromStorage() {
        if let userData = UserDefaults.standard.data(forKey: userDefaultsKey),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            currentUser = user
            isAuthenticated = true
            showOnboarding = user.isFirstLogin
        }
    }
    
    private func saveUserToStorage(_ user: User) {
        if let userData = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(userData, forKey: userDefaultsKey)
        }
    }
    
    private func extractNameFromEmail(_ email: String) -> String {
        let components = email.components(separatedBy: "@")
        return components.first?.capitalized ?? "User"
    }
}
