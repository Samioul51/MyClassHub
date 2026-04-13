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
        
        ZStack {
            
            // MARK: BACKGROUND
            Color(hex: "#110e07")
                .ignoresSafeArea()
            
            Group {
                
                if viewModel.isLoading {
                    
                    ProgressView("Loading...")
                        .tint(Color(hex: "#8dedec"))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                } else {
                    
                    ScrollView {
                        
                        VStack(spacing: 18) {
                            
                            ForEach(grouped, id: \.0) { designation, teachers in
                                
                                VStack(alignment: .leading, spacing: 12) {
                                    
                                    // SECTION TITLE
                                    Text(designation.uppercased())
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(Color(hex: "#8dedec"))
                                        .tracking(2)
                                        .padding(.horizontal, 4)
                                    
                                    // TEACHER LIST
                                    VStack(spacing: 10) {
                                        
                                        ForEach(teachers) { teacher in
                                            
                                            NavigationLink(destination: TeacherDetailView(teacher: teacher)) {
                                                TeacherRowView(teacher: teacher)
                                            }
                                            .buttonStyle(.plain)
                                        }
                                    }
                                }
                                .padding(16)
                                .background(Color(hex: "#16130b"))
                                .cornerRadius(20)
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .navigationTitle("Our Teachers")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Our Teachers")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "#8dedec"))
            }
        }
        .task {
            await viewModel.fetchTeachers()
        }
    }
}
