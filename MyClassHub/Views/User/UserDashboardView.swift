//
//  UserDashboardView.swift
//  MyClassHub
//
//  Created by SIR on 16/3/26.
//

import SwiftUI

struct UserDashboardView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            Text("User Dashboard")
                .navigationTitle("My Class Hub")
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
