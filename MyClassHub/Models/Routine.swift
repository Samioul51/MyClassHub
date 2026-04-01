//
//  Routine.swift
//  MyClassHub
//
//  Created by AI on 16/3/26.
//
import Foundation

struct ClassRoutine: Identifiable {
    var id: String
    var session: String          // e.g. "2023-2024"
    var year: String             // e.g. "3rd Year"
    var term: String             // e.g. "2nd Term"
    var startDate: String        // e.g. "09-12-2025"
    var sections: [RoutineSection]
}

struct RoutineSection: Identifiable {
    var id: String
    var name: String             // e.g. "SEC-A", "SEC-B"
    var roomInfo: String         // e.g. "Theory: 306, Lab: ..."
    var schedule: [DaySchedule]
}

struct DaySchedule: Identifiable {
    var id: String
    var day: String              // e.g. "Sunday", "Monday"
    var slots: [ClassSlot]
}

struct ClassSlot: Identifiable {
    var id: String
    
    var period: Int              // Starting period (1–9)
    var duration: Int            // 1 = theory, 3 = lab
    
    var timeStart: String        // e.g. "08:00"
    var timeEnd: String          // e.g. "08:50" OR "01:10" for lab
    
    var courseCode: String       // e.g. "CSE 3219"
    var courseName: String       // e.g. "Software Engineering"
    var teacherInitials: [String]
    
    var isLab: Bool
    var groupInfo: String?
}
