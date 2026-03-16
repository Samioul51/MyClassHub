//
//  MyClassHubApp.swift
//  MyClassHub
//
//  Created by SIR on 13/3/26.
//

import SwiftUI
import Firebase

@main
struct MyClassHubApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authViewModel)
        }
    }
}
