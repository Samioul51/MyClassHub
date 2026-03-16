//
//  RegisterView.swift
//  MyClassHub
//
//  Created by SIR on 16/3/26.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var roll = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                Text("Create Account")
                    .font(.title.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)
                
                Group {
                    TextField("Full Name", text: $name)
                    TextField("Roll Number", text: $roll)
                        .keyboardType(.numberPad)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    SecureField("Password", text: $password)
                    SecureField("Confirm Password", text: $confirmPassword)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                
                if !authViewModel.errorMessage.isEmpty {
                    Text(authViewModel.errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                Button {
                    guard password == confirmPassword else {
                        authViewModel.errorMessage = "Passwords do not match"
                        return
                    }
                    Task {
                        await authViewModel.register(
                            name: name, roll: roll,
                            email: email, password: password
                        )
                    }
                } label: {
                    Text("Register")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .disabled(authViewModel.isLoading)
            }
            .padding(.horizontal, 24)
        }
    }
}
