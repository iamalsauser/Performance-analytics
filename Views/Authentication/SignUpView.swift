import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var name = ""
    @State private var selectedRole: UserRole = .player
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Create Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                
                VStack(spacing: 16) {
                    TextField("Full Name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    SecureField("Confirm Password", text: $confirmPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    // Role Selection
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Select Your Role")
                            .font(.headline)
                        
                        ForEach(UserRole.allCases, id: \.self) { role in
                            Button(action: {
                                selectedRole = role
                            }) {
                                HStack {
                                    Image(systemName: selectedRole == role ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(selectedRole == role ? role.color : .gray)
                                    Text(role.rawValue)
                                        .foregroundColor(.primary)
                                    Spacer()
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                    .padding(.top)
                }
                .padding(.horizontal, 40)
                
                Button(action: {
                    Task {
                        await authViewModel.signUp(email: email, password: password, name: name, role: selectedRole)
                        dismiss()
                    }
                }) {
                    HStack {
                        if authViewModel.isLoading {
                            ProgressView()
                                .scaleEffect(0.8)
                        }
                        Text("Create Account")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(selectedRole.color)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding(.horizontal, 40)
                .disabled(authViewModel.isLoading || password != confirmPassword || name.isEmpty)
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
