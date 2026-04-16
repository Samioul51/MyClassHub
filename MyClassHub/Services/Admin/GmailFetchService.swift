//
//  GmailFetchService.swift
//  MyClassHub
//
//  Created by AI on 17/4/26.
//

import Foundation

class GmailFetchService {

    private let baseURL = "https://gmail.googleapis.com/gmail/v1/users/me"

    // MARK: - Fetch Inbox Message IDs

    func fetchMessageIDs(
        accessToken: String,
        label: String = "INBOX",
        maxResults: Int = 20,
        completion: @escaping (Result<[String], Error>) -> Void
    ) {
        let urlString = "\(baseURL)/messages?maxResults=\(maxResults)&labelIds=\(label)"
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }
            guard
                let data = data,
                let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                let messages = json["messages"] as? [[String: Any]]
            else {
                DispatchQueue.main.async { completion(.failure(URLError(.cannotParseResponse))) }
                return
            }
            let ids = messages.compactMap { $0["id"] as? String }
            DispatchQueue.main.async { completion(.success(ids)) }
        }.resume()
    }

    // MARK: - Fetch Single Message Detail

    func fetchMessageDetail(
        id: String,
        accessToken: String,
        completion: @escaping (Result<MailMessage, Error>) -> Void
    ) {
        let urlString = "\(baseURL)/messages/\(id)?format=metadata&metadataHeaders=From,Subject,Date"
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }
            guard let data = data else { return }
            if let message = self.parseMessage(id: id, data: data) {
                DispatchQueue.main.async { completion(.success(message)) }
            } else {
                DispatchQueue.main.async { completion(.failure(URLError(.cannotParseResponse))) }
            }
        }.resume()
    }

    // MARK: - Fetch Connected Email (Profile)

    func fetchUserEmail(
        accessToken: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        guard let url = URL(string: "\(baseURL)/profile") else { return }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }
            guard
                let data = data,
                let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                let email = json["emailAddress"] as? String
            else {
                DispatchQueue.main.async { completion(.failure(URLError(.cannotParseResponse))) }
                return
            }
            DispatchQueue.main.async { completion(.success(email)) }
        }.resume()
    }

    // MARK: - Parser

    private func parseMessage(id: String, data: Data) -> MailMessage? {
        guard
            let json    = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
            let payload = json["payload"] as? [String: Any],
            let headers = payload["headers"] as? [[String: Any]]
        else { return nil }

        func header(_ name: String) -> String {
            headers.first { ($0["name"] as? String) == name }?["value"] as? String ?? ""
        }

        let labelIDs  = json["labelIds"] as? [String] ?? []
        let snippet   = json["snippet"] as? String ?? ""
        let from      = header("From")
        let subject   = header("Subject")
        let date      = header("Date")

        let senderName = from.components(separatedBy: "<").first?
            .trimmingCharacters(in: .whitespaces) ?? from

        let initials = senderName
            .components(separatedBy: " ")
            .prefix(2)
            .compactMap { $0.first.map { String($0) } }
            .joined()
            .uppercased()

        let avatarColors = ["#8dedec", "#91f78e", "#f0a843", "#e07ee0"]
        let avatarColor  = avatarColors[abs(senderName.hashValue) % avatarColors.count]

        return MailMessage(
            id:              id,
            sender:          senderName,
            senderInitials:  initials.isEmpty ? "?" : initials,
            subject:         subject.isEmpty ? "(no subject)" : subject,
            preview:         snippet,
            time:            formatDate(date),
            isUnread:        labelIDs.contains("UNREAD"),
            isImportant:     labelIDs.contains("IMPORTANT"),
            avatarColor:     avatarColor
        )
    }

    private func formatDate(_ raw: String) -> String {
        let formatters: [DateFormatter] = [
            { let f = DateFormatter(); f.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"; return f }(),
            { let f = DateFormatter(); f.dateFormat = "dd MMM yyyy HH:mm:ss Z"; return f }(),
        ]
        for formatter in formatters {
            if let date = formatter.date(from: raw) {
                let display = DateFormatter()
                if Calendar.current.isDateInToday(date) {
                    display.dateFormat = "h:mm a"
                } else if Calendar.current.isDateInWeek(date) {
                    display.dateFormat = "EEE"
                } else {
                    display.dateFormat = "MMM d"
                }
                return display.string(from: date)
            }
        }
        return raw
    }
}

private extension Calendar {
    func isDateInWeek(_ date: Date) -> Bool {
        guard let weekAgo = self.date(byAdding: .day, value: -7, to: Date()) else { return false }
        return date >= weekAgo
    }
}
