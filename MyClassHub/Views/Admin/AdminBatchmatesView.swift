import SwiftUI

struct AdminBatchmatesView: View {
    @StateObject private var vm = BatchmateViewModel()
    @State private var showAdd = false
    @State private var selected: Batchmate?
    @State private var showDelete = false

    var body: some View {
        ZStack {
            Color(hex: "#110e07").ignoresSafeArea()
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ]) {
                    ForEach(vm.batchmates) { b in
                        AdminBatchmateCard(
                            batchmate: b,
                            onDelete: {
                                selected = b
                                showDelete = true
                            },
                            onEdit: {
                                Task { await vm.fetchBatchmates() } 
                            }
                        )
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // Center Title
            ToolbarItem(placement: .principal) {
                Text("Batchmates")
                    .foregroundColor(.white)
                    .font(.headline)
            }

            // Plus Button
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showAdd = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.teal)
                }
            }
        }
        .sheet(isPresented: $showAdd, onDismiss: {
            Task { await vm.fetchBatchmates() }
        }) {
            AddBatchmateView()
        }
        .alert("Delete?", isPresented: $showDelete) {
            Button("Delete", role: .destructive) {
                if let s = selected {
                    Task { await vm.deleteBatchmate(id: s.id) }
                }
            }
            Button("Cancel", role: .cancel) {}
        }
        .task { await vm.fetchBatchmates() }
    }
}
