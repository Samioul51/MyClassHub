//
//  RoutineViewModel.swift
//  MyClassHub
//
//  Created by AI on 16/3/26.
//
import Foundation

@MainActor
class RoutineViewModel: ObservableObject {
    @Published var routine: ClassRoutine? = nil
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var selectedSection: String = "SEC-A"
    @Published var selectedDay: String = "Sunday"

    let days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday"]

    var availableSections: [String] {
        routine?.sections.map { $0.name } ?? []
    }

    var currentSection: RoutineSection? {
        routine?.sections.first { $0.name == selectedSection }
    }

    var currentDaySchedule: DaySchedule? {
        currentSection?.schedule.first { $0.day == selectedDay }
    }

    var currentRoomInfo: String {
        currentSection?.roomInfo ?? ""
    }

    func fetchRoutine() async {
        isLoading = true
        do {
            routine = try await RoutineService.shared.fetchRoutine(
                year: "3rd Year",
                term: "2nd Term"
            )
            // Default to today's day if available
            let today = todayName()
            if days.contains(today) {
                selectedDay = today
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    private func todayName() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: Date())
    }
}
