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
    
    private var displayTime: String {
        extractOnlyTime(from: notice.time) ?? "TBA"
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
                    MetaChip(icon: "clock", text: displayTime)
                }
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
    
    private func extractOnlyTime(from value: String?) -> String? {
        guard let value = value?.trimmingCharacters(in: .whitespacesAndNewlines),
              !value.isEmpty else { return nil }
        
        if let lastPart = value.components(separatedBy: " - ").last?
            .trimmingCharacters(in: .whitespacesAndNewlines),
           containsTime(lastPart) {
            return normalizedTime(lastPart)
        }
        
        if let range = value.range(of: #"\b\d{1,2}:\d{2}\s?(?:AM|PM|am|pm)\b"#, options: .regularExpression) {
            return normalizedTime(String(value[range]))
        }
        
        return value
    }
    
    private func containsTime(_ value: String) -> Bool {
        value.range(of: #"\b\d{1,2}:\d{2}\s?(?:AM|PM|am|pm)\b"#, options: .regularExpression) != nil
    }
    
    private func normalizedTime(_ value: String) -> String {
        value.uppercased().replacingOccurrences(of: " ", with: "")
    }
}

struct NoticeDetailView: View {
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
    
    private var displayTime: String {
        extractOnlyTime(from: notice.time) ?? "TBA"
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
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
                            .font(.system(size: 12, weight: .medium, design: .monospaced))
                            .foregroundColor(.secondary)
                    }
                    
                    Text(notice.title)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    if notice.category.isAssessment {
                        VStack(spacing: 10) {
                            DetailMetaRow(icon: "mappin.and.ellipse", title: "Location", value: notice.location ?? "TBA")
                            DetailMetaRow(icon: "clock", title: "Time", value: displayTime)
                            
                            if notice.category != .viva, let syllabus = notice.syllabus, !syllabus.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                DetailMetaRow(icon: "doc.text", title: "Syllabus", value: syllabus)
                            }
                        }
                    }
                }
                .padding(18)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Description")
                        .font(.system(.headline, design: .rounded))
                    
                    Text(notice.description)
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                        .lineSpacing(5)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(18)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Notice")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func extractOnlyTime(from value: String?) -> String? {
        guard let value = value?.trimmingCharacters(in: .whitespacesAndNewlines),
              !value.isEmpty else { return nil }
        
        if let lastPart = value.components(separatedBy: " - ").last?
            .trimmingCharacters(in: .whitespacesAndNewlines),
           containsTime(lastPart) {
            return normalizedTime(lastPart)
        }
        
        if let range = value.range(of: #"\b\d{1,2}:\d{2}\s?(?:AM|PM|am|pm)\b"#, options: .regularExpression) {
            return normalizedTime(String(value[range]))
        }
        
        return value
    }
    
    private func containsTime(_ value: String) -> Bool {
        value.range(of: #"\b\d{1,2}:\d{2}\s?(?:AM|PM|am|pm)\b"#, options: .regularExpression) != nil
    }
    
    private func normalizedTime(_ value: String) -> String {
        value.uppercased().replacingOccurrences(of: " ", with: "")
    }
}

struct DetailMetaRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.secondary)
                
                Text(title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.secondary)
            }
            
            Text(value)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
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
