//
//  AdminNoticeView.swift
//  MyClassHub
//
//  Created by AI on 31/3/26.
//

import SwiftUI

struct AdminNoticeView: View {
    @Environment(\.dismiss) private var dismiss
    
    private let editingNotice: Notice?
    private let onSave: (() -> Void)?
    
    @State private var title: String
    @State private var desc: String
    @State private var category: NoticeCategory
    @State private var syllabus: String
    @State private var location: String
    @State private var time: String
    @State private var isPosting = false
    
    private let service = NoticeService()
    
    init(editingNotice: Notice? = nil, onSave: (() -> Void)? = nil) {
        self.editingNotice = editingNotice
        self.onSave = onSave
        
        _title = State(initialValue: editingNotice?.title ?? "")
        _desc = State(initialValue: editingNotice?.description ?? "")
        _category = State(initialValue: editingNotice?.category ?? .general)
        _syllabus = State(initialValue: editingNotice?.syllabus ?? "")
        _location = State(initialValue: editingNotice?.location ?? "")
        _time = State(initialValue: editingNotice?.time ?? "")
    }
    
    var body: some View {
        Form {
            Section("Basic Information") {
                TextField("Title (e.g., CSE-201 Quiz)", text: $title)
                
                Picker("Type", selection: $category) {
                    ForEach(NoticeCategory.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                
                MultilineInputField(
                    title: "Description",
                    text: $desc,
                    minHeight: 90
                )
            }
            
            if category.isAssessment {
                Section("Assessment Details") {
                    if category != .viva {
                        MultilineInputField(
                            title: "Syllabus",
                            text: $syllabus,
                            minHeight: 90
                        )
                    }
                    
                    MultilineInputField(
                        title: "Location (Room/Lab)",
                        text: $location,
                        minHeight: 80
                    )
                    
                    MultilineInputField(
                        title: "Time",
                        text: $time,
                        minHeight: 80
                    )
                }
            }
            
            Section {
                Button {
                    saveNotice()
                } label: {
                    HStack {
                        Spacer()
                        if isPosting {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text(editingNotice == nil ? "Publish Notice" : "Update Notice")
                                .font(.system(.body, design: .rounded, weight: .bold))
                        }
                        Spacer()
                    }
                }
                .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isPosting)
                .listRowBackground(
                    title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isPosting
                    ? Color.gray.opacity(0.3)
                    : Color.blue
                )
            }
            .foregroundColor(.white)
        }
        .navigationTitle(editingNotice == nil ? "New Notice" : "Edit Notice")
    }
    
    private func saveNotice() {
        guard !isPosting else { return }
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        isPosting = true
        
        let notice = Notice(
            id: editingNotice?.id,
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            description: desc.trimmingCharacters(in: .whitespacesAndNewlines),
            date: editingNotice?.date ?? Date(),
            category: category,
            location: category.isAssessment ? emptyToNil(location) : nil,
            time: category.isAssessment ? emptyToNil(time) : nil,
            syllabus: (category.isAssessment && category != .viva) ? emptyToNil(syllabus) : nil,
            deadline: editingNotice?.deadline
        )
        
        Task {
            do {
                if editingNotice == nil {
                    try await service.uploadNotice(notice)
                } else {
                    try await service.updateNotice(notice)
                }
                
                try? await Task.sleep(nanoseconds: 300_000_000)
                
                await MainActor.run {
                    isPosting = false
                    onSave?()
                    dismiss()
                }
            } catch {
                await MainActor.run {
                    print("DEBUG: Failed to save notice: \(error.localizedDescription)")
                    isPosting = false
                }
            }
        }
    }
    
    private func emptyToNil(_ value: String) -> String? {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
}

struct MultilineInputField: View {
    let title: String
    @Binding var text: String
    var minHeight: CGFloat = 80
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Text(title)
                    .foregroundColor(.secondary.opacity(0.7))
                    .padding(.top, 8)
                    .padding(.leading, 5)
            }
            
            TextEditor(text: $text)
                .frame(minHeight: minHeight)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
        }
    }
}
