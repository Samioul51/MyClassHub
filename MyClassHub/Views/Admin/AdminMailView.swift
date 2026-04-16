//
//  AdminMailView.swift
//  MyClassHub
//
//  Created by AI on 17/4/26.
//

import SwiftUI

struct AdminMailView: View {
    @StateObject private var viewModel = AdminMailViewModel()
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color(hex: "#110e07").ignoresSafeArea()

            VStack(spacing: 0) {
                MailHeaderView(
                    isConnected:    viewModel.isConnected,
                    connectedEmail: viewModel.connectedEmail,
                    onDisconnect:   viewModel.disconnect
                )

                if !viewModel.isConnected {
                    ConnectMailBannerView(onConnect: {
                        DispatchQueue.main.async {
                            guard let scene = UIApplication.shared.connectedScenes
                                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
                                  let window = scene.windows.first(where: { $0.isKeyWindow }),
                                  var rootVC = window.rootViewController else { return }
                            
                            // Traverse to the topmost presented view controller
                            while let presented = rootVC.presentedViewController {
                                rootVC = presented
                            }
                            
                            viewModel.connect(presentingViewController: rootVC)
                        }
                    })
                } else {
                    MailTabBarView(selected: Binding(
                        get: { viewModel.selectedTab },
                        set: { viewModel.selectedTab = $0 }
                    ))

                    MailStatsRowView(
                        unread:    viewModel.unreadCount,
                        total:     viewModel.messages.count,
                        important: viewModel.importantCount
                    )
                    .padding(.horizontal)
                    .padding(.bottom, 12)

                    MailListView(
                        messages:  viewModel.filteredMessages,
                        isLoading: viewModel.isLoading,
                        onRefresh: { viewModel.loadEmails() }
                    )
                }

                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.system(size: 12))
                        .foregroundColor(.red.opacity(0.8))
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                }
            }
        }
        .navigationBarHidden(true)
    }
}
