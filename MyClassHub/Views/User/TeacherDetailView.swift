//
//  TeacherDetailView.swift
//  MyClassHub
//
//  Created by SIR on 16/3/26.
//

import SwiftUI

struct TeacherDetailView: View {
    
    let teacher: Teacher
    
    var body: some View {
        
        ZStack {
            
            // MARK: BACKGROUND
            Color(hex: "#110e07")
                .ignoresSafeArea()
            
            ScrollView {
                
                VStack(spacing: 20) {
                    
                    // MARK: PROFILE CARD
                    VStack(spacing: 14) {
                        
                        AsyncImage(url: URL(string: teacher.image)) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                
                            case .failure, .empty:
                                Image(systemName: "person.circle.fill")
                                    .font(.system(size: 60))
                                    .foregroundColor(Color(hex: "#8dedec"))
                                
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .frame(width: 110, height: 110)
                        .clipShape(Circle())
                        .background(Color(hex: "#1d1910"))
                        .overlay(
                            Circle()
                                .stroke(Color(hex: "#8dedec").opacity(0.4), lineWidth: 2)
                        )
                        
                        Text(teacher.name)
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        Text(teacher.designation)
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(24)
                    .background(Color(hex: "#16130b"))
                    .cornerRadius(24)
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    // MARK: CONTACT SECTION
                    VStack(spacing: 1) {
                        
                        // EMAIL
                        Button {
                            if let url = URL(string: "mailto:\(teacher.email)") {
                                UIApplication.shared.open(url)
                            }
                        } label: {
                            ContactRow(
                                icon: "envelope.fill",
                                color: Color(hex: "#4dafaf"),
                                title: "Email",
                                value: teacher.email
                            )
                        }
                        
                        Divider()
                            .background(Color.white.opacity(0.08))
                            .padding(.leading, 56)
                        
                        // PHONE
                        if let phone = teacher.phone, !phone.isEmpty {
                            Button {
                                if let url = URL(string: "tel:\(phone)") {
                                    UIApplication.shared.open(url)
                                }
                            } label: {
                                ContactRow(
                                    icon: "phone.fill",
                                    color: Color(hex: "#91f78e"),
                                    title: "Phone",
                                    value: phone
                                )
                            }
                        } else {
                            ContactRow(
                                icon: "phone.fill",
                                color: .gray,
                                title: "Phone",
                                value: "Not available"
                            )
                            .opacity(0.5)
                        }
                    }
                    .background(Color(hex: "#16130b"))
                    .cornerRadius(20)
                    .padding(.horizontal)
                    
                    Spacer(minLength: 40)
                }
            }
        }
        .navigationTitle(teacher.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(teacher.name)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#8dedec"))
            }
        }
    }
}

// Contact row
struct ContactRow: View {
    
    let icon: String
    let color: Color
    let title: String
    let value: String
    
    var body: some View {
        
        HStack(spacing: 14) {
            
            Image(systemName: icon)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 34, height: 34)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading, spacing: 2) {
                
                Text(title)
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.5))
                
                Text(value)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white.opacity(0.3))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}
