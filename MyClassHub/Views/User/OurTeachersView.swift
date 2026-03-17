//
//  OurTeachersView.swift
//  MyClassHub
//
//  Created by SIR on 16/3/26.
//

import SwiftUI

struct OurTeachersView: View {
    @StateObject private var viewModel = TeacherViewModel()

    // Grouped by designation
    
    var grouped: [(String, [Teacher])] {
        let order = ["Professor", "Associate Professor", "Assistant Professor", "Lecturer"]
        let dict = Dictionary(grouping: viewModel.teachers, by: { $0.designation })
        return order.compactMap { key in
            guard let values = dict[key], !values.isEmpty else { return nil }
            return (key, values)
        }
    }

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(grouped, id: \.0) { designation, teachers in
                        Section(designation) {
                            ForEach(teachers) { teacher in
                                NavigationLink(destination: TeacherDetailView(teacher: teacher)) {
                                    TeacherRowView(teacher: teacher)
                                }
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle("Our Teachers")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchTeachers()
        }
    }
}
