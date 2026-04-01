//
//  AdminDashboardView.swift
//  MyClassHub
//
//  Created by SIR on 16/3/26.
//

import SwiftUI

struct AdminDashboardView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showingLogoutConfirmation = false
    
    // Grid configuration for management cards
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        // MARK: - Admin Hero Header
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Administrator")
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color.red.opacity(0.1))
                                .foregroundColor(.red)
                                .cornerRadius(8)
                            
                            Text("Control Center")
                                .font(.system(size: 34, weight: .bold, design: .rounded))
                            
                            Text("Manage schedules, faculty, and notices.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        
                        // MARK: - Content Management Grid
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Content Management")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            LazyVGrid(columns: columns, spacing: 16) {
                                AdminGridCard(
                                    title: "Routine",
                                    subtitle: "Update Schedule",
                                    icon: "calendar.badge.plus",
                                    color: .blue,
                                    destination: AnyView(AdminRoutineView())
                                )
                                
                                AdminGridCard(
                                    title: "Teachers",
                                    subtitle: "Manage Faculty",
                                    icon: "person.badge.plus",
                                    color: .purple,
                                    destination: AnyView(Text("Teacher Management"))
                                )
                                
                                AdminGridCard(
                                    title: "Notices",
                                    subtitle: "Manage Updates",
                                    icon: "bell.badge.fill",
                                    color: .orange,
                                    destination: AnyView(AdminNoticeManagementView())
                                )
                                
                                AdminGridCard(
                                    title: "Students",
                                    subtitle: "Roll Directory",
                                    icon: "person.2.circle.fill",
                                    color: .green,
                                    destination: AnyView(Text("Student Management"))
                                )
                            }
                            .padding(.horizontal)
                        }
                        
                        // MARK: - Quick Actions
                        VStack(alignment: .leading, spacing: 12) {
                            Text("User Experience")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            NavigationLink(destination: UserDashboardView()) {
                                HStack {
                                    Image(systemName: "arrow.left.arrow.right.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.blue)
                                    VStack(alignment: .leading) {
                                        Text("Switch to Student View")
                                            .fontWeight(.semibold)
                                        Text("View app as a regular user")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .background(Color(.systemBackground))
                                .cornerRadius(16)
                                .shadow(color: .black.opacity(0.03), radius: 5, x: 0, y: 2)
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal)
                        }
                        
                        // MARK: - Danger Zone
                        VStack(spacing: 12) {
                            Button(role: .destructive) {
                                showingLogoutConfirmation = true
                            } label: {
                                HStack {
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                    Text("Logout from System")
                                        .fontWeight(.bold)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red.opacity(0.1))
                                .foregroundColor(.red)
                                .cornerRadius(16)
                            }
                            .padding(.horizontal)
                            .padding(.top, 20)
                        }
                        
                        Spacer(minLength: 40)
                    }
                }
            }
            .navigationBarHidden(true)
            .confirmationDialog(
                "Logout",
                isPresented: $showingLogoutConfirmation,
                titleVisibility: .visible
            ) {
                Button("Logout", role: .destructive) {
                    authViewModel.logout()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Are you sure you want to end your administrative session?")
            }
        }
    }
}

// MARK: - Supporting Views

struct AdminGridCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let destination: AnyView
    
    var body: some View {
        NavigationLink(destination: destination) {
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                    .frame(width: 48, height: 48)
                    .background(color.opacity(0.15))
                    .cornerRadius(12)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
}
