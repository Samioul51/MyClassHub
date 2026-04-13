import SwiftUI

struct NoticeListView: View {
    @StateObject var viewModel = NoticeViewModel()
    @State private var selectedCategory: NoticeCategory = .general

    var body: some View {
        ZStack {
            
            // MARK: BACKGROUND (ADMIN THEME)
            Color(hex: "#110e07")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                // MARK: CATEGORY SELECTOR (DARK CHIPS)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        
                        ForEach(NoticeCategory.allCases, id: \.self) { cat in
                            
                            Button(action: {
                                selectedCategory = cat
                            }) {
                                Text(cat.rawValue)
                                    .font(.system(size: 13, weight: .bold, design: .rounded))
                                    .foregroundColor(
                                        selectedCategory == cat
                                        ? Color(hex: "#110e07")
                                        : .white.opacity(0.7)
                                    )
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(
                                        selectedCategory == cat
                                        ? Color(hex: "#8dedec")
                                        : Color(hex: "#16130b")
                                    )
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                }
                
                Divider()
                    .background(Color.white.opacity(0.1))
                
                // MARK: NOTICE LIST
                ScrollView {
                    
                    LazyVStack(spacing: 14) {
                        
                        let filtered = viewModel.filteredNotices(for: selectedCategory)
                        
                        if filtered.isEmpty {
                            
                            EmptyStateNoticeView(selectedCategory: selectedCategory.rawValue)
                                .padding(.top, 80)
                            
                        } else {
                            
                            ForEach(filtered) { notice in
                                
                                NavigationLink(destination: NoticeDetailView(notice: notice)) {
                                    NoticeCardView(notice: notice)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)
                }
                .refreshable {
                    viewModel.fetchNotices()
                }
            }
        }
        .navigationTitle("Bulletin Board")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Bulletin Board")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#8dedec"))
            }
        }
        .task {
            viewModel.fetchNotices()
        }
    }
}



struct NoticeCardView: View {
    let notice: Notice

    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            
            HStack {
                
                Label(notice.category.rawValue, systemImage: notice.category.icon)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Color(hex: "#8dedec"))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color(hex: "#1d1910"))
                    .cornerRadius(20)
                
                Spacer()
                
                Text(notice.date, style: .date)
                    .font(.system(size: 11, weight: .medium, design: .monospaced))
                    .foregroundColor(.white.opacity(0.5))
            }

            VStack(alignment: .leading, spacing: 4) {
                
                Text(notice.title)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text(notice.description)
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.6))
                    .lineLimit(3)
            }
        }
        .padding(16)
        .background(Color(hex: "#16130b"))
        .cornerRadius(18)
    }
}


struct NoticeDetailView: View {
    let notice: Notice
    
    @StateObject private var commentVM = NoticeCommentViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        
        ZStack {
            
            Color(hex: "#110e07")
                .ignoresSafeArea()
            
            ScrollView {
                
                VStack(alignment: .leading, spacing: 18) {
                    
                    // MARK: MAIN CARD
                    VStack(alignment: .leading, spacing: 12) {
                        
                        HStack {
                            
                            Label(notice.category.rawValue, systemImage: notice.category.icon)
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(Color(hex: "#8dedec"))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color(hex: "#1d1910"))
                                .cornerRadius(20)
                            
                            Spacer()
                            
                            Text(notice.date, style: .date)
                                .font(.system(size: 12))
                                .foregroundColor(.white.opacity(0.5))
                        }
                        
                        Text(notice.title)
                            .font(.system(size: 26, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text(notice.description)
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.7))
                            .lineSpacing(5)
                    }
                    .padding(18)
                    .background(Color(hex: "#16130b"))
                    .cornerRadius(20)
                    
                    // MARK: COMMENTS
                    VStack(alignment: .leading, spacing: 16) {
                        
                        Text("Comments")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color(hex: "#8dedec"))
                        
                        if commentVM.comments.isEmpty {
                            
                            Text("No comments yet.")
                                .foregroundColor(.white.opacity(0.5))
                        }
                        
                        ForEach(commentVM.comments) { comment in
                            
                            VStack(alignment: .leading, spacing: 6) {
                                
                                HStack {
                                    
                                    Text(comment.userName)
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Text(comment.createdAt.formatted())
                                        .font(.caption2)
                                        .foregroundColor(.white.opacity(0.4))
                                }
                                
                                Text(comment.text)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            .padding()
                            .background(Color(hex: "#16130b"))
                            .cornerRadius(12)
                        }
                        
                        // COMMENT INPUT
                        HStack {
                            
                            TextField("Write comment...", text: $commentVM.newComment)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color(hex: "#1d1910"))
                                .cornerRadius(12)
                            
                            Button("Send") {
                                
                                guard let id = notice.id else { return }
                                
                                Task {
                                    await commentVM.addComment(
                                        noticeId: id,
                                        userId: authViewModel.currentUser?.id ?? "",
                                        userName: authViewModel.currentUser?.name ?? "User"
                                    )
                                }
                            }
                            .foregroundColor(Color(hex: "#8dedec"))
                        }
                    }
                    .padding()
                    .background(Color(hex: "#16130b"))
                    .cornerRadius(20)
                }
                .padding()
            }
        }
        .navigationTitle("Notice")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Notice")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#8dedec"))
            }
        }
        .task {
            guard let id = notice.id else { return }
            await commentVM.fetchComments(for: id)
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
