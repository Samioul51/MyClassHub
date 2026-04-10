//
//  NoticeListView.swift
//  MyClassHub
//
//  Created by Mridul on 31/3/26.
//

import SwiftUI

struct NoticeListView: View {
    @StateObject var viewModel = NoticeViewModel()
    @State private var selectedCategory: NoticeCategory = .general

    var body: some View {
        VStack(spacing: 0) {

            // MARK: Category Selector
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(NoticeCategory.allCases, id: \.self) { cat in
                        CategoryTabButton(
                            title: cat.rawValue,
                            isSelected: selectedCategory == cat
                        ) {
                            selectedCategory = cat
                        }
                    }
                }
                .padding()
            }
            .background(Color(.systemBackground))

            // MARK: Notice List
            ScrollView {
                LazyVStack(spacing: 16) {
                    let filtered = viewModel.filteredNotices(for: selectedCategory)

                    if filtered.isEmpty {
                        EmptyStateNoticeView(selectedCategory: selectedCategory.rawValue)
                            .padding(.top, 100)
                    } else {
                        ForEach(filtered) { notice in
                            NavigationLink(destination: NoticeDetailView(notice: notice)) {
                                NoticeCardView(notice: notice)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .refreshable {
                viewModel.fetchNotices()
            }
        }
        .navigationTitle("Bulletin Board")
    }
}

struct NoticeCardView: View {
    let notice: Notice

    private var categoryColor: Color {
        switch notice.category {
        case .ct: return Color(red: 0.23, green: 0.51, blue: 0.96)
        case .labTest: return Color(red: 0.39, green: 0.40, blue: 0.95)
        case .quiz: return Color(red: 0.98, green: 0.45, blue: 0.09)
        case .project: return Color(red: 0.66, green: 0.33, blue: 0.97)
        case .viva: return Color(red: 0.13, green: 0.77, blue: 0.37)
        case .general: return Color(.systemGray3)
        }
    }

    private var displayTime: String {
        extractOnlyTime(from: notice.time) ?? "TBA"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            HStack {
                Label(notice.category.rawValue, systemImage: notice.category.icon)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(categoryColor)
                    .padding(.horizontal, 11)
                    .padding(.vertical, 4)
                    .background(categoryColor.opacity(0.10))
                    .clipShape(Capsule())

                Spacer()

                Text(notice.date, style: .date)
                    .font(.system(size: 11, weight: .medium, design: .monospaced))
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(notice.title)
                    .font(.system(size: 15, weight: .semibold))
                    .lineLimit(2)

                Text(notice.description)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }

            if notice.category.isAssessment {
                HStack(spacing: 8) {
                    MetaChip(icon: "mappin.and.ellipse", text: notice.location ?? "TBA")
                    MetaChip(icon: "clock", text: displayTime)
                }
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func extractOnlyTime(from value: String?) -> String? {
        guard let value else { return nil }
        return value
    }
}

struct NoticeDetailView: View {
    let notice: Notice

    @StateObject private var commentVM = NoticeCommentViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel

    private var categoryColor: Color {
        switch notice.category {
        case .ct: return Color(red: 0.23, green: 0.51, blue: 0.96)
        case .labTest: return Color(red: 0.39, green: 0.40, blue: 0.95)
        case .quiz: return Color(red: 0.98, green: 0.45, blue: 0.09)
        case .project: return Color(red: 0.66, green: 0.33, blue: 0.97)
        case .viva: return Color(red: 0.13, green: 0.77, blue: 0.37)
        case .general: return Color(.systemGray3)
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {

                // MARK: Main Notice Card
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Label(notice.category.rawValue, systemImage: notice.category.icon)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(categoryColor)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(categoryColor.opacity(0.10))
                            .clipShape(Capsule())

                        Spacer()

                        Text(notice.date, style: .date)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                    }

                    Text(notice.title)
                        .font(.system(size: 28, weight: .bold, design: .rounded))

                    Text(notice.description)
                        .foregroundColor(.secondary)
                        .lineSpacing(5)
                }
                .padding(18)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 20))

                // MARK: Comments Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Comments")
                        .font(.headline)

                    if commentVM.comments.isEmpty {
                        Text("No comments yet. Be the first to comment.")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                    }

                    ForEach(commentVM.comments) { comment in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(comment.userName)
                                    .fontWeight(.semibold)

                                Spacer()

                                Text(
                                    comment.createdAt.formatted(
                                        date: .abbreviated,
                                        time: .shortened
                                    )
                                )
                                .font(.caption)
                                .foregroundColor(.secondary)
                            }

                            Text(comment.text)
                                .foregroundColor(.primary)
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                    }

                    HStack {
                        TextField("Write a comment...", text: $commentVM.newComment)
                            .textFieldStyle(.roundedBorder)

                        Button("Send") {
                            guard let noticeId = notice.id else { return }

                            Task {
                                await commentVM.addComment(
                                    noticeId: noticeId,
                                    userId: authViewModel.currentUser?.id ?? "",
                                    userName: authViewModel.currentUser?.name ?? "Anonymous"
                                )
                            }
                        }
                        .disabled(
                            commentVM.newComment
                                .trimmingCharacters(in: .whitespacesAndNewlines)
                                .isEmpty
                        )
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(20)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Notice")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            guard let noticeId = notice.id else { return }
            await commentVM.fetchComments(for: noticeId)
        }
    }
}

struct MetaChip: View {
    let icon: String
    let text: String

    var body: some View {
        Label(text, systemImage: icon)
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(.secondary)
            .padding(.horizontal, 11)
            .padding(.vertical, 5)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)
    }
}

struct CategoryTabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: isSelected ? .bold : .medium))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color.primary.opacity(0.05))
                .foregroundColor(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

struct EmptyStateNoticeView: View {
    let selectedCategory: String

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "tray.and.arrow.down")
                .font(.system(size: 50))
                .foregroundColor(.secondary.opacity(0.4))

            Text("No \(selectedCategory) Notices")
                .font(.headline)

            Text("Everything is up to date for now.")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.top, 40)
    }
}
