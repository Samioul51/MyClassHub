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

                // MARK: - Header
                HStack {
                    Button { dismiss() } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(hex: "#8dedec"))
                            .frame(width: 40, height: 40)
                            .background(Color(hex: "#1d1910"))
                            .clipShape(Circle())
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text("University Mail")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(Color(hex: "#8dedec"))

                        Text(viewModel.isConnected
                             ? viewModel.connectedEmail.uppercased()
                             : "NOT CONNECTED")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(viewModel.isConnected
                                             ? Color(hex: "#91f78e")
                                             : .orange)
                            .tracking(1.2)
                    }

                    Spacer()

                    if viewModel.isConnected {
                        Button { viewModel.disconnect() } label: {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .font(.system(size: 15))
                                .foregroundColor(.red.opacity(0.8))
                                .frame(width: 40, height: 40)
                                .background(Color(hex: "#1d1910"))
                                .clipShape(Circle())
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                .padding(.bottom, 16)

                // MARK: - Body
                if !viewModel.isConnected {
                    ConnectMailBannerView(onConnect: {
                        DispatchQueue.main.async {
                            guard let scene = UIApplication.shared.connectedScenes
                                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
                                  let window = scene.windows.first(where: { $0.isKeyWindow }),
                                  var rootVC = window.rootViewController else { return }

                            while let presented = rootVC.presentedViewController {
                                rootVC = presented
                            }

                            viewModel.connect(presentingViewController: rootVC)
                        }
                    })
                } else {
                    MailTabBarView(selected: $viewModel.selectedTab)

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

                // MARK: - Error
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
