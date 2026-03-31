//
//  AdminNoticeView.swift
//  MyClassHub
//
//  Created by AI on 31/3/26.
//

import SwiftUI

struct AdminNoticeView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var desc = ""
    @State private var category = NoticeCategory.general
    @State private var syllabus = ""
    @State private var location = ""
    @State private var time = ""
    @State private var isPosting = false
    
    private let service = NoticeService()

    var body: some View {
        Form {
            Section("Basic Information") {
                TextField("Title (e.g., CSE-201 Quiz)", text: $title)
                
                Picker("Type", selection: $category) {
                    ForEach(NoticeCategory.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                
                TextField("Description", text: $desc, axis: .vertical)
                    .lineLimit(3...6)
            }
            
            // Assessment Details: hidden for general/project, syllabus hidden for viva
            if category.isAssessment {
                Section("Assessment Details") {
                    if category != .viva {
                        TextField("Syllabus", text: $syllabus)
                    }
                    TextField("Location (Room/Lab)", text: $location)
                    TextField("Time", text: $time)
                }
            }
            
            Section {
                Button {
                    postNotice()
                } label: {
                    HStack {
                        Spacer()
                        if isPosting {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Publish Notice")
                                .font(.system(.body, design: .rounded, weight: .bold))
                        }
                        Spacer()
                    }
                }
                .disabled(title.isEmpty || isPosting)
                .listRowBackground(title.isEmpty || isPosting ? Color.gray.opacity(0.3) : Color.blue)
            }
            .foregroundColor(.white)
        }
        .navigationTitle("New Notice")
    }
    
    private func postNotice() {
        // Prevent double-tap
        guard !isPosting else { return }
        
        isPosting = true
        
        let notice = Notice(
            title: title,
            description: desc,
            date: Date(),
            category: category,
            location: category.isAssessment ? location : nil,
            time: category.isAssessment ? time : nil,
            syllabus: (category.isAssessment && category != .viva) ? syllabus : nil
        )
        
        Task {
            do {
                try await service.uploadNotice(notice)
                try? await Task.sleep(nanoseconds: 500_000_000)
                
                // UI updates must happen on the main thread
                await MainActor.run {
                    isPosting = false
                    dismiss()
                }
            } catch {
                await MainActor.run {
                    print("DEBUG: Failed to upload notice: \(error.localizedDescription)")
                    isPosting = false
                }
            }
        }
    }
}
