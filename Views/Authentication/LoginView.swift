import SwiftUI

struct LoginView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var email = ""
    @State private var password = ""
    @State private var showSignUp = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                // Logo and Title
                VStack(spacing: 16) {
                    Image(systemName: "basketball.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.orange)
                    
                    Text("Basketball Analytics")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Track, Analyze, Improve")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 50)
                
                // Login Form
                VStack(spacing: 20) {
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    if !authViewModel.errorMessage.isEmpty {
                        Text(authViewModel.errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                    Button(action: {
                        Task {
                            await authViewModel.signIn(email: email, password: password)
                        }
                    }) {
                        HStack {
                            if authViewModel.isLoading {
                                ProgressView()
                                    .scaleEffect(0.8)
                            }
                            Text("Sign In")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .disabled(authViewModel.isLoading)
                    
                    Button("Don't have an account? Sign Up") {
                        showSignUp = true
                    }
                    .foregroundColor(.orange)
                }
                .padding(.horizontal, 40)
                
                Spacer()
            }
            .sheet(isPresented: $showSignUp) {
                SignUpView()
                    .environmentObject(authViewModel)
            }
        }
        .environmentObject(authViewModel)
    }
}
