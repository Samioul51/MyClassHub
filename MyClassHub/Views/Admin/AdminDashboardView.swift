//
//  AdminDashboardView.swift
//  MyClassHub
//
//  Created by SIR on 16/3/26.
//

import SwiftUI

struct AdminDashboardView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            Text("Admin Dashboard")
                .navigationTitle("Admin Dashboard")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Logout") {
                            authViewModel.logout()
                        }
                        .foregroundColor(.red)
                    }
                }
        }
    }
}
