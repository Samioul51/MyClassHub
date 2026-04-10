//
//  UserDashboardView.swift
//  MyClassHub
//
//  Created by SIR on 16/3/26.
//

import SwiftUI

struct UserDashboardView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    // Grid configuration for a balanced 2-column layout
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                // Background layer
                Image("background")
                    .resizable()
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 28) {
                        
                        // MARK: - Header Section
                        headerSection
                        
                        // MARK: - Services Grid
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Academic Services")
                                .font(.system(.headline, design: .rounded))
                                .padding(.horizontal)
                                .foregroundColor(.white)
                            
                            LazyVGrid(columns: columns, spacing: 16) {
                                DashboardGridCard(
                                    title: "Batchmates",
                                    subtitle: "Class Directory",
                                    icon: "person.2.fill",
                                    color: .blue,
                                    destination: AnyView(MyBatchmatesView())
                                )
                                
                                DashboardGridCard(
                                    title: "Routine",
                                    subtitle: "Class Schedule",
                                    icon: "calendar",
                                    color: .indigo,
                                    destination: AnyView(RoutineView())
                                )
                                
                                DashboardGridCard(
                                    title: "Notices",
                                    subtitle: "Announcements",
                                    icon: "bell.fill",
                                    color: .orange,
                                    destination: AnyView(NoticeListView())
                                )
                                
                                DashboardGridCard(
                                    title: "Teachers",
                                    subtitle: "Faculty Info",
                                    icon: "graduationcap.fill",
                                    color: .purple,
                                    destination: AnyView(OurTeachersView())
                                )
                            }
                            .padding(.horizontal)
                        }

                        // MARK: - Admin Access (Conditional)
                        if authViewModel.isAdmin {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("System Administration")
                                    .font(.system(.headline, design: .rounded))
                                    .padding(.horizontal)
                                    .foregroundColor(.white)
                                
                                NavigationLink(destination: AdminDashboardView()) {
                                    HStack(spacing: 16) {
                                        Image(systemName: "shield.lefthalf.filled")
                                            .font(.title2)
                                            .foregroundColor(.red)
                                            .frame(width: 48, height: 48)
                                            .background(Color.red.opacity(0.1))
                                            .cornerRadius(12)
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("Admin Control Center")
                                                .font(.system(.body, design: .rounded, weight: .bold))
                                            Text("Manage routine and faculty")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(.secondary.opacity(0.5))
                                    }
                                    .padding()
                                    .background(Color(.systemBackground))
                                    .cornerRadius(20)
                                    .shadow(color: .black.opacity(0.03), radius: 5, x: 0, y: 2)
                                }
                                .buttonStyle(.plain)
                                .padding(.horizontal)
                            }
                        }

                        // MARK: - Account Preferences
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Preferences")
                                .font(.system(.headline, design: .rounded))
                                .padding(.horizontal)
                                .foregroundColor(.white)
                            
                            NavigationLink(destination: SettingsView()) {
                                HStack {
                                    Label("App Settings", systemImage: "gearshape.fill")
                                        .font(.system(.body, design: .rounded, weight: .medium))
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(.secondary.opacity(0.5))
                                }
                                .padding()
                                .background(Color(.systemBackground))
                                .cornerRadius(16)
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal)
                        }
                        
                        Spacer(minLength: 40)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }

    // MARK: - Subviews
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Top Status Row
            HStack {
                Text("STUDENT PROFILE")
                    .font(.system(size: 10, weight: .black))
                    .foregroundColor(.blue)
                    .tracking(1.2)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .clipShape(Capsule())
                
                Spacer()
                
                // Roll Number Pill
                HStack(spacing: 6) {
                    Text("ROLL")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text(authViewModel.currentUser?.roll ?? "-")
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .foregroundColor(.black)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .strokeBorder(Color.primary.opacity(0.1), lineWidth: 1)
                        .background(Color(.tertiarySystemGroupedBackground).clipShape(Capsule()))
                )
            }

            // Greeting and Subtitle
            VStack(alignment: .leading, spacing: 4) {
                Text(authViewModel.currentUser?.name ?? "Student")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text("Your academic overview and services.")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .fontWeight(.heavy)
            }
        }
        .padding(.horizontal)
        .padding(.top, 20)
    }
}

// MARK: - Reusable Components

struct DashboardGridCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let destination: AnyView
    
    var body: some View {
        NavigationLink(destination: destination) {
            VStack(alignment: .leading, spacing: 14) {
                Image(systemName: icon)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(color)
                    .frame(width: 44, height: 44)
                    .background(color.opacity(0.12))
                    .cornerRadius(12)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(.body, design: .rounded, weight: .bold))
                        .foregroundColor(.primary)
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
