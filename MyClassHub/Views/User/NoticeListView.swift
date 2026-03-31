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
            // Category Selector
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(NoticeCategory.allCases, id: \.self) { cat in
                        CategoryTabButton(title: cat.rawValue, isSelected: selectedCategory == cat) {
                            selectedCategory = cat
                        }
                    }
                }
                .padding()
            }
            .background(Color(.systemBackground))
            
            // List Content
            ScrollView {
                LazyVStack(spacing: 16) {
                    let filtered = viewModel.filteredNotices(for: selectedCategory)
                    
                    if filtered.isEmpty {
                        EmptyStateNoticeView(selectedCategory: selectedCategory.rawValue)
                            .padding(.top, 100)
                    } else {
                        ForEach(filtered) { notice in
                            NoticeCardView(notice: notice)
                        }
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .refreshable { viewModel.fetchNotices() }
        }
        .navigationTitle("Bulletin Board")
    }
}

struct NoticeCardView: View {
    let notice: Notice

    private var categoryColor: Color {
        switch notice.category {
        case .ct:      return Color(red: 0.23, green: 0.51, blue: 0.96)
        case .labTest: return Color(red: 0.39, green: 0.40, blue: 0.95)
        case .quiz:    return Color(red: 0.98, green: 0.45, blue: 0.09)
        case .project: return Color(red: 0.66, green: 0.33, blue: 0.97)
        case .viva:    return Color(red: 0.13, green: 0.77, blue: 0.37)
        case .general: return Color(.systemGray3)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Header
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

            // Content
            VStack(alignment: .leading, spacing: 3) {
                Text(notice.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(2)

                Text(notice.description)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                    .lineSpacing(1.5)
            }

            // Chips
            if notice.category.isAssessment {
                HStack(spacing: 8) {
                    MetaChip(icon: "mappin.and.ellipse", text: notice.location ?? "TBA")
                    MetaChip(icon: "clock", text: (notice.time?.components(separatedBy: " - ").last) ?? "TBA")
                }
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
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

// MARK: - Supporting Views
struct CategoryTabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: isSelected ? .bold : .medium, design: .rounded))
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
                .foregroundColor(.secondary)
            
            Text("Everything is up to date for now.")
                .font(.subheadline)
                .foregroundColor(.secondary.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 40)
    }
}
