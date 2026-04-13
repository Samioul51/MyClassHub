import SwiftUI

struct AdminDashboardView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showingLogoutConfirmation = false
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                Color(hex: "#110e07")
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            
                            // HEADER
                            HStack {
                                HStack(spacing: 12) {
                                    Image("jonathan_avatar")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 44, height: 44)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color(hex: "#8dedec"), lineWidth: 1))
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("Admin Panel")
                                            .font(.system(size: 20, weight: .bold, design: .rounded))
                                            .foregroundColor(Color(hex: "#8dedec"))
                                        
                                        Text("ADMINISTRATOR")
                                            .font(.system(size: 10, weight: .bold))
                                            .foregroundColor(Color(hex: "#91f78e"))
                                            .tracking(1.5)
                                    }
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    showingLogoutConfirmation = true
                                }) {
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
                            
                            // BANNER
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
                                        Text("CAMPUS VIEW")
                                            .font(.system(size: 10, weight: .bold))
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 4)
                                            .background(Color(hex: "#006e1c"))
                                            .cornerRadius(20)
                                        
                                        Text("KUET campus")
                                            .font(.system(size: 28, weight: .bold, design: .rounded))
                                            .foregroundColor(.white)
                                    }
                                    .padding(20)
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Control Center")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(Color(hex: "#8dedec"))
                                    
                                    Text("Manage schedules, faculty, and notices.")
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
                            
                            // GRID
                            LazyVGrid(columns: columns, spacing: 16) {
                                
                                AdminGridCard(
                                    title: "Routine",
                                    subtitle: "Update Schedule",
                                    icon: "calendar",
                                    color: Color(hex: "#1d1910"),
                                    destination: AnyView(AdminRoutineView())
                                )
                                
                                AdminGridCard(
                                    title: "Teachers",
                                    subtitle: "Manage Faculty",
                                    icon: "person.fill",
                                    color: Color(hex: "#1d1910"),
                                    destination: AnyView(Text("Teacher Management"))
                                )
                                
                                AdminGridCard(
                                    title: "Notices",
                                    subtitle: "Manage Updates",
                                    icon: "bell.fill",
                                    color: Color(hex: "#1d1910"),
                                    destination: AnyView(AdminNoticeManagementView())
                                )
                                
                                AdminGridCard(
                                    title: "Students",
                                    subtitle: "Roll Directory",
                                    icon: "person.2.fill",
                                    color: Color(hex: "#1d1910"),
                                    destination: AnyView(Text("Student Management"))
                                )
                            }
                            .padding(.horizontal)
                            
                            // CONFIG
                            VStack(alignment: .leading, spacing: 16) {
                                
                                Text("CONFIGURATION")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white.opacity(0.4))
                                    .tracking(2)
                                    .padding(.horizontal)
                                
                                VStack(spacing: 1) {
                                    
                                    Button(action: {
                                        authViewModel.switchToStudentMode()
                                    }) {
                                        ConfigRow(
                                            icon: "eye.fill",
                                            title: "Switch to Student View",
                                            subtitle: "Preview the mobile experience"
                                        )
                                    }
                                    
                                    Button(action: {
                                        showingLogoutConfirmation = true
                                    }) {
                                        ConfigRow(
                                            icon: "gearshape.fill",
                                            title: "App Settings",
                                            subtitle: "Global system preferences"
                                        )
                                    }
                                }
                                .background(Color(hex: "#16130b"))
                                .cornerRadius(24)
                                .padding(.horizontal)
                            }
                            
                            Spacer(minLength: 120)
                        }
                    }
                }
                
                // BOTTOM BAR
                VStack {
                    Spacer()
                    BottomAdminBar()
                }
                .ignoresSafeArea(edges: .bottom)
            }
            .navigationBarHidden(true)
            
            // ALERT
            .alert("Are you sure you want to logout?", isPresented: $showingLogoutConfirmation) {
                Button("Logout", role: .destructive) {
                    authViewModel.logout()
                }
                Button("Cancel", role: .cancel) {}
            }
        }
    }
}

//
// MARK: GRID CARD (FIXED NAVIGATION)
//
struct AdminGridCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let destination: AnyView
    
    var body: some View {
        NavigationLink(destination: destination) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Image(systemName: icon)
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "#91f78e"))
                        .frame(width: 40, height: 40)
                        .background(Color.white.opacity(0.05))
                        .clipShape(Circle())
                }
                
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.6))
            }
            .padding(20)
            .background(Color(hex: "#16130b"))
            .cornerRadius(24)
        }
        .buttonStyle(.plain)
    }
}

//
// MARK: CONFIG ROW
//
struct ConfigRow: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(Color(hex: "#8dedec"))
                .frame(width: 44, height: 44)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.5))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white.opacity(0.3))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
}

//
// MARK: BOTTOM BAR
//
struct BottomAdminBar: View {
    var body: some View {
        HStack {
            Spacer()
            
            NavigationLink(destination: AdminDashboardView()) {
                BottomItem(icon: "shield.fill", title: "Admin")
            }
            
            Spacer()
            
            NavigationLink(destination: UserDashboardView()) {
                BottomItem(icon: "person.fill", title: "Student")
            }
            
            Spacer()
            
            NavigationLink(destination: SettingsView()) {
                BottomItem(icon: "gearshape.fill", title: "Settings")
            }
            
            Spacer()
        }
        .padding(.vertical, 12)
        .background(
            LinearGradient(colors: [Color.teal, Color.green],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
        )
    }
}

//
// MARK: BOTTOM ITEM
//
struct BottomItem: View {
    let icon: String
    let title: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .frame(width: 35, height: 35)
                .foregroundColor(.white)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.white)
        }
    }
}
