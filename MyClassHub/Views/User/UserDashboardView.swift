//
//  UserDashboardView.swift
//  MyClassHub
//
//  Created by SIR on 16/3/26.
//

import SwiftUI

struct UserDashboardView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                // SAME BACKGROUND AS ADMIN
                Color(hex: "#110e07")
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            
                            // MARK: HEADER (SAME STYLE AS ADMIN)
                            HStack {
                                HStack(spacing: 12) {
                                    
                                    Image(systemName: "person.crop.circle.fill")
                                        .font(.system(size: 34))
                                        .foregroundColor(Color(hex: "#8dedec"))
                                        .frame(width: 44, height: 44)
                                        .background(Color(hex: "#1d1910"))
                                        .clipShape(Circle())
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("User Panel")
                                            .font(.system(size: 20, weight: .bold, design: .rounded))
                                            .foregroundColor(Color(hex: "#8dedec"))
                                        
                                        Text("STUDENT")
                                            .font(.system(size: 10, weight: .bold))
                                            .foregroundColor(Color(hex: "#91f78e"))
                                            .tracking(1.5)
                                    }
                                }
                                
                                Spacer()
                                
                                Button(action: {}) {
                                    Image(systemName: "bell.fill")
                                        .font(.system(size: 18))
                                        .foregroundColor(Color(hex: "#8dedec"))
                                        .frame(width: 44, height: 44)
                                        .background(Color(hex: "#1d1910"))
                                        .clipShape(Circle())
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top, 10)
                            
                            // MARK: BANNER (SAME STRUCTURE AS ADMIN)
                            VStack(alignment: .leading, spacing: 0) {
                                
                                ZStack(alignment: .bottomLeading) {
                                    
                                    Image("kuetswc")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 220)
                                        .clipped()
                                        .cornerRadius(32)
                                    
                                    LinearGradient(
                                        colors: [Color.black.opacity(0.8), Color.clear],
                                        startPoint: .bottom,
                                        endPoint: .center
                                    )
                                    .cornerRadius(32)
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        
                                        Text("STUDENT VIEW")
                                            .font(.system(size: 10, weight: .bold))
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 4)
                                            .background(Color(hex: "#006e1c"))
                                            .cornerRadius(20)
                                        
                                        Text(authViewModel.currentUser?.name ?? "Student")
                                            .font(.system(size: 28, weight: .bold, design: .rounded))
                                            .foregroundColor(.white)
                                    }
                                    .padding(20)
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Control Center")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(Color(hex: "#8dedec"))
                                    
                                    Text("Access academic services and information.")
                                        .font(.system(size: 14))
                                        .foregroundColor(.white.opacity(0.7))
                                }
                                .padding(24)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(hex: "#16130b"))
                                .cornerRadius(32)
                                .offset(y: 10)
                                .padding(.horizontal, 16)
                            }
                            
                            // MARK: GRID (SAME STYLE AS ADMIN)
                            LazyVGrid(columns: columns, spacing: 16) {
                                
                                AdminGridCard(
                                    title: "Batchmates",
                                    subtitle: "Class Directory",
                                    icon: "person.2.fill",
                                    color: Color(hex: "#4dafaf"),
                                    destination: AnyView(MyBatchmatesView())
                                )
                                
                                AdminGridCard(
                                    title: "Routine",
                                    subtitle: "Class Schedule",
                                    icon: "calendar",
                                    color: Color(hex: "#006e1c"),
                                    destination: AnyView(RoutineView())
                                )
                                
                                AdminGridCard(
                                    title: "Notices",
                                    subtitle: "Announcements",
                                    icon: "bell.fill",
                                    color: Color(hex: "#ff9f0a"),
                                    destination: AnyView(NoticeListView())
                                )
                                
                                AdminGridCard(
                                    title: "Teachers",
                                    subtitle: "Faculty Info",
                                    icon: "graduationcap.fill",
                                    color: Color(hex: "#8dedec"),
                                    destination: AnyView(OurTeachersView())
                                )
                            }
                            .padding(.horizontal)
                            
                            // MARK: ADMIN ACCESS (same style logic)
                            if authViewModel.canAccessAdminPanel {
                                
                                VStack(alignment: .leading, spacing: 16) {
                                    
                                    Text("SYSTEM ACCESS")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(.white.opacity(0.4))
                                        .tracking(2)
                                        .padding(.horizontal)
                                    
                                    NavigationLink(destination: AdminDashboardView()) {
                                        
                                        HStack {
                                            
                                            Image(systemName: "shield.fill")
                                                .font(.system(size: 18))
                                                .foregroundColor(Color(hex: "#ff3b30"))
                                                .frame(width: 44, height: 44)
                                                .background(Color(hex: "#1d1910"))
                                                .clipShape(Circle())
                                            
                                            VStack(alignment: .leading) {
                                                Text("Admin Control Center")
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 16, weight: .bold))
                                                
                                                Text("Manage system")
                                                    .foregroundColor(.white.opacity(0.5))
                                                    .font(.caption)
                                            }
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.white.opacity(0.3))
                                        }
                                        .padding(18)
                                        .background(Color(hex: "#16130b"))
                                        .cornerRadius(20)
                                    }
                                    .buttonStyle(.plain)
                                    .simultaneousGesture(TapGesture().onEnded {
                                        authViewModel.returnToAdminMode()
                                    })
                                    .padding(.horizontal)
                                }
                            }
                            
                            // MARK: SETTINGS
                            VStack(alignment: .leading, spacing: 16) {
                                
                                Text("PREFERENCES")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white.opacity(0.4))
                                    .tracking(2)
                                    .padding(.horizontal)
                                
                                NavigationLink(destination: SettingsView()) {
                                    
                                    HStack {
                                        Label("App Settings", systemImage: "gearshape.fill")
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.white.opacity(0.3))
                                    }
                                    .padding()
                                    .background(Color(hex: "#16130b"))
                                    .cornerRadius(16)
                                }
                                .buttonStyle(.plain)
                                .padding(.horizontal)
                            }
                            
                            Spacer(minLength: 120)
                        }
                    }
                }
                
                // SAME BOTTOM BAR AS ADMIN
                VStack {
                    Spacer()
                    BottomAdminBar()
                }
                .ignoresSafeArea(edges: .bottom)
            }
            .navigationBarHidden(true)
        }
    }
}
