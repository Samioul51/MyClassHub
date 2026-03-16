//
//  RootView.swift
//  MyClassHub
//
//  Created by SIR on 16/3/26.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        Group {
            if authViewModel.isLoading {
                LoadingView()
            }
            else if !authViewModel.isLoggedIn {
                LoginView()
            }
            else if authViewModel.isAdmin {
                AdminDashboardView()
            }
            else {
                UserDashboardView()
            }
        }
    }
}
