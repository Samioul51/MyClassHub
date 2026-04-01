//
//  AdminNoticeManagementView.swift
//  MyClassHub
//
//  Created by AI on 1/4/26.
//

import SwiftUI

struct AdminNoticeManagementView: View {
    @StateObject private var viewModel = NoticeViewModel()
    @State private var showingCreateSheet = false
    @State private var selectedNotice: Notice?
    @State private var noticeToDelete: Notice?
    
    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.notices.isEmpty {
                VStack(spacing: 16) {
                    ProgressView()
                    Text("Loading notices...")
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemGroupedBackground))
            } else if viewModel.notices.isEmpty {
                AdminEmptyNoticeStateView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemGroupedBackground))
            } else {
                List {
                    ForEach(viewModel.notices) { notice in
                        AdminNoticeRowView(
                            notice: notice,
                            onEdit: {
                                selectedNotice = notice
                            }
                        )
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                noticeToDelete = notice
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            
                            Button {
                                selectedNotice = notice
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.blue)
                        }
                    }
                }
                .listStyle(.insetGrouped)
                .refreshable {
                    viewModel.fetchNotices()
                }
            }
        }
        .navigationTitle("Manage Notices")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingCreateSheet = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingCreateSheet) {
            NavigationStack {
                AdminNoticeView {
                    viewModel.fetchNotices()
                }
            }
        }
        .sheet(item: $selectedNotice) { notice in
            NavigationStack {
                AdminNoticeView(editingNotice: notice) {
                    viewModel.fetchNotices()
                }
            }
        }
        .alert("Delete Notice?", isPresented: Binding(
            get: { noticeToDelete != nil },
            set: { if !$0 { noticeToDelete = nil } }
        )) {
            Button("Delete", role: .destructive) {
                guard let notice = noticeToDelete else { return }
                
                Task {
                    await viewModel.deleteNotice(notice)
                    noticeToDelete = nil
                }
            }
            
            Button("Cancel", role: .cancel) {
                noticeToDelete = nil
            }
        } message: {
            Text("This notice will be permanently removed.")
        }
    }
}

struct AdminNoticeRowView: View {
    let notice: Notice
    let onEdit: () -> Void
    
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
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top, spacing: 10) {
                    Label(notice.category.rawValue, systemImage: notice.category.icon)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(categoryColor)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(categoryColor.opacity(0.10))
                        .clipShape(Capsule())
                    
                    Spacer()
                    
                    Text(notice.date, style: .date)
                        .font(.system(size: 11, weight: .medium, design: .monospaced))
                        .foregroundColor(.secondary)
                }
                
                Text(notice.title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                Text(notice.description)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                if notice.category.isAssessment {
                    HStack(spacing: 10) {
                        AdminMetaChip(
                            icon: "mappin.and.ellipse",
                            text: notice.location ?? "TBA"
                        )
                        
                        AdminMetaChip(
                            icon: "clock",
                            text: displayTime
                        )
                    }
                }
            }
            
            Button(action: onEdit) {
                Image(systemName: "square.and.pencil")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.blue)
                    .frame(width: 38, height: 38)
                    .background(Color.blue.opacity(0.10))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }
            .buttonStyle(.plain)
            .padding(.top, 2)
        }
        .padding(.vertical, 6)
    }
    
    private func extractOnlyTime(from value: String?) -> String? {
        guard let value = value?.trimmingCharacters(in: .whitespacesAndNewlines),
              !value.isEmpty else { return nil }
        
        if let lastPart = value.components(separatedBy: " - ").last?
            .trimmingCharacters(in: .whitespacesAndNewlines),
           containsTime(lastPart) {
            return lastPart
        }
        
        if let range = value.range(of: #"\b\d{1,2}:\d{2}\s?(?:AM|PM|am|pm)\b"#, options: .regularExpression) {
            return String(value[range]).uppercased().replacingOccurrences(of: " ", with: "")
        }
        
        return value
    }
    
    private func containsTime(_ value: String) -> Bool {
        value.range(of: #"\b\d{1,2}:\d{2}\s?(?:AM|PM|am|pm)\b"#, options: .regularExpression) != nil
    }
}

struct AdminMetaChip: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 11, weight: .semibold))
            
            Text(text)
                .font(.system(size: 12, weight: .semibold))
                .lineLimit(1)
                .minimumScaleFactor(0.9)
        }
        .foregroundColor(.secondary)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

struct AdminEmptyNoticeStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "bell.slash")
                .font(.system(size: 46))
                .foregroundColor(.secondary.opacity(0.5))
            
            Text("No Notices Yet")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("Create your first notice using the plus button above.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
        }
    }
}
