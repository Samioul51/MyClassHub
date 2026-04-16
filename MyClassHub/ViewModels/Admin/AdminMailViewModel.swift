//
//  AdminMailViewModel.swift
//  MyClassHub
//
//  Created by AI on 17/4/26.
//

import UIKit
import Foundation
import Combine

class AdminMailViewModel: ObservableObject {

    @Published var isConnected    = false
    @Published var connectedEmail = ""
    @Published var messages: [MailMessage] = []
    @Published var selectedTab: MailTab = .inbox
    @Published var isLoading      = false
    @Published var errorMessage: String?

    private let authService  = GmailAuthService(role: "admin")
    private let fetchService = GmailFetchService()

    // MARK: - Init

    init() {
        if let token = authService.storedAccessToken,
           let email = authService.storedEmail {
            isConnected    = true
            connectedEmail = email
            loadEmails(accessToken: token)
        }
    }

    // MARK: - Computed

    var filteredMessages: [MailMessage] {
        switch selectedTab {
        case .inbox:     return messages
        case .sent:      return []
        case .important: return messages.filter { $0.isImportant }
        }
    }

    var unreadCount:    Int { messages.filter { $0.isUnread }.count }
    var importantCount: Int { messages.filter { $0.isImportant }.count }

    // MARK: - Connect

    func connect(presentingViewController: UIViewController) {
        #if targetEnvironment(simulator)
        // Mock mode for simulator — bypass Google Sign-In
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.authService.storedEmail       = "islam2107044@stud.kuet.ac.bd"
            self.authService.storedAccessToken = "mock_token"
            self.connectedEmail = "islam2107044@stud.kuet.ac.bd"
            self.isConnected    = true
            self.loadMockEmails()
        }
        #else
        DispatchQueue.main.async {
            self.isLoading = true
            self.authService.startOAuthFlow(
                presentingViewController: presentingViewController
            ) { [weak self] result in
                DispatchQueue.main.async {
                    guard let self else { return }
                    switch result {
                    case .success(let token):
                        self.connectedEmail = self.authService.storedEmail ?? ""
                        self.isConnected    = true
                        self.isLoading      = false
                        self.loadEmails(accessToken: token)
                    case .failure(let error):
                        self.isLoading    = false
                        self.errorMessage = error.localizedDescription
                    }
                }
            }
        }
        #endif
    }

    // MARK: - Load Emails

    func loadEmails(accessToken: String? = nil) {
        #if targetEnvironment(simulator)
        loadMockEmails()
        #else
        guard let token = accessToken ?? authService.storedAccessToken else { return }
        isLoading    = true
        errorMessage = nil

        fetchService.fetchMessageIDs(accessToken: token) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let ids):
                self.fetchDetails(for: ids, accessToken: token)
            case .failure(let error):
                self.isLoading    = false
                self.errorMessage = error.localizedDescription
            }
        }
        #endif
    }

    // MARK: - Mock Emails (Simulator only)

    private func loadMockEmails() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.messages = [
                MailMessage(
                    id: "1",
                    sender: "Dr. Hassan (HOD)",
                    senderInitials: "DH",
                    subject: "Semester Final Exam Schedule",
                    preview: "Please circulate to all students by tomorrow morning.",
                    time: "10:32 AM",
                    isUnread: true,
                    isImportant: true,
                    avatarColor: "#8dedec"
                ),
                MailMessage(
                    id: "2",
                    sender: "Admin Controller",
                    senderInitials: "AC",
                    subject: "Notice: Lab Access Update",
                    preview: "New lab access policy effective from Monday onwards.",
                    time: "Yesterday",
                    isUnread: true,
                    isImportant: false,
                    avatarColor: "#91f78e"
                ),
                MailMessage(
                    id: "3",
                    sender: "Registrar's Office",
                    senderInitials: "RO",
                    subject: "Updated Course Registration Form",
                    preview: "Attached is the revised form for 4th year students.",
                    time: "Mon",
                    isUnread: false,
                    isImportant: false,
                    avatarColor: "#f0a843"
                ),
                MailMessage(
                    id: "4",
                    sender: "KUET Events",
                    senderInitials: "KE",
                    subject: "Annual Tech Fest — CR Briefing",
                    preview: "Your presence is required at the pre-event meeting.",
                    time: "Sun",
                    isUnread: false,
                    isImportant: true,
                    avatarColor: "#8dedec"
                ),
                MailMessage(
                    id: "5",
                    sender: "Prof. Rahman",
                    senderInitials: "PR",
                    subject: "Assignment Submission Deadline Extended",
                    preview: "The deadline has been extended to next Friday.",
                    time: "Sat",
                    isUnread: false,
                    isImportant: false,
                    avatarColor: "#91f78e"
                )
            ]
            self.isLoading = false
        }
    }

    // MARK: - Fetch Details

    private func fetchDetails(for ids: [String], accessToken: String) {
        let group   = DispatchGroup()
        var fetched = [MailMessage]()
        let lock    = NSLock()

        for id in ids {
            group.enter()
            fetchService.fetchMessageDetail(id: id, accessToken: accessToken) { result in
                if case .success(let mail) = result {
                    lock.lock()
                    fetched.append(mail)
                    lock.unlock()
                }
                group.leave()
            }
        }

        group.notify(queue: .main) { [weak self] in
            self?.messages  = fetched.sorted { $0.time > $1.time }
            self?.isLoading = false
        }
    }

    // MARK: - Disconnect

    func disconnect() {
        authService.logout()
        isConnected    = false
        connectedEmail = ""
        messages       = []
    }
}
