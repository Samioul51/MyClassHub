//
//  MyBatchmatesView.swift
//  MyClassHub
//
//  Created by SIR on 16/3/26.
//

import SwiftUI

struct MyBatchmatesView: View {
    @StateObject private var viewModel = BatchmateViewModel()
    @State private var searchText = ""

    var filtered: [Batchmate] {
        if searchText.isEmpty { return viewModel.batchmates }
        return viewModel.batchmates.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.roll.contains(searchText)
        }
    }

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVGrid(
                        columns: [GridItem(.flexible()), GridItem(.flexible())],
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
        .navigationTitle("My Batchmates")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, prompt: "Search by name or roll")
        .task {
            await viewModel.fetchBatchmates()
        }
    }
}
