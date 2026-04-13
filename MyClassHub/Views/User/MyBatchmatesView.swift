import SwiftUI

struct MyBatchmatesView: View {
    
    @StateObject private var viewModel = BatchmateViewModel()
    @State private var searchText = ""
    
    var filtered: [Batchmate] {
        if searchText.isEmpty {
            return viewModel.batchmates
        }
        return viewModel.batchmates.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.roll.contains(searchText)
        }
    }
    
    var body: some View {
        
        ZStack {
            
            // MARK: BACKGROUND (ADMIN THEME)
            Color(hex: "#110e07")
                .ignoresSafeArea()
            
            Group {
                
                if viewModel.isLoading {
                    
                    ProgressView("Loading...")
                        .tint(Color(hex: "#8dedec"))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                } else {
                    
                    VStack(spacing: 0) {
                        
                        // MARK: SEARCH BAR (DARK STYLE)
                        HStack {
                            
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.white.opacity(0.5))
                            
                            TextField("Search by name or roll", text: $searchText)
                                .foregroundColor(.white)
                            
                            if !searchText.isEmpty {
                                Button {
                                    searchText = ""
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.white.opacity(0.5))
                                }
                            }
                        }
                        .padding()
                        .background(Color(hex: "#16130b"))
                        .cornerRadius(16)
                        .padding(.horizontal)
                        .padding(.top, 10)
                        
                        // MARK: GRID
                        ScrollView {
                            
                            LazyVGrid(
                                columns: [
                                    GridItem(.flexible(), spacing: 12),
                                    GridItem(.flexible(), spacing: 12)
                                ],
                                spacing: 12
                            ) {
                                
                                ForEach(Array(filtered.enumerated()), id: \.element.id) { index, batchmate in
                                    
                                    NavigationLink(
                                        destination: BatchmateDetailView(
                                            batchmates: filtered,
                                            selectedIndex: index
                                        )
                                    ) {
                                        BatchmateCardView(batchmate: batchmate)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(16)
                        }
                    }
                }
            }
        }
        .navigationTitle("My Batchmates")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("My Batchmates")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#8dedec"))
            }
        }
        .task {
            await viewModel.fetchBatchmates()
        }
    }
}
