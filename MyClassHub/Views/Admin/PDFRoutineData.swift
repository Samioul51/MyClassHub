//
//  PDFRoutineData.swift
//  MyClassHub
//
//  Created by AI on 31/3/26.
//

import Foundation

struct PDFRoutineData {
    
    static let routine = ClassRoutine(
        id: "3rd-year-2nd-term-2023-2024",
        session: "2023-2024",
        year: "3rd Year",
        term: "2nd Term",
        startDate: "09-12-2025",
        sections: [secA, secB]
    )
    
    // MARK: - SEC A
    static let secA = RoutineSection(
        id: "sec-a",
        name: "SEC-A",
        roomInfo: "Theory: 306, Lab: CSE-201, 103, 202, 306",
        schedule: [
            DaySchedule(id: "a-sun", day: "Sunday", slots: [
                ClassSlot(id: "a-sun-1", period: 1, duration: 1, timeStart: "08:00", timeEnd: "08:50", courseCode: "CSE 3219", courseName: "Software Engineering and Project Management", teacherInitials: ["EK"], isLab: false, groupInfo: nil),
                ClassSlot(id: "a-sun-2", period: 2, duration: 1, timeStart: "08:50", timeEnd: "09:40", courseCode: "CSE 3217", courseName: "Mobile Computing", teacherInitials: ["LBM"], isLab: false, groupInfo: nil),
                ClassSlot(id: "a-sun-3", period: 3, duration: 1, timeStart: "09:40", timeEnd: "10:30", courseCode: "CSE 3211", courseName: "Compiler Design", teacherInitials: ["AH"], isLab: false, groupInfo: nil),
                // Lab Block (A1: SE Lab, A2: Mobile Lab)
                ClassSlot(id: "a-sun-lab-a1", period: 4, duration: 3, timeStart: "10:40", timeEnd: "01:10", courseCode: "CSE 3220", courseName: "Software Engineering and Project Management Laboratory", teacherInitials: ["SA", "NFS"], isLab: true, groupInfo: "A1"),
                ClassSlot(id: "a-sun-lab-a2", period: 4, duration: 3, timeStart: "10:40", timeEnd: "01:10", courseCode: "CSE 3218", courseName: "Mobile Computing Laboratory", teacherInitials: ["MRI", "KFI"], isLab: true, groupInfo: "A2")
            ]),
            
            DaySchedule(id: "a-mon", day: "Monday", slots: [
                ClassSlot(id: "a-mon-4", period: 4, duration: 1, timeStart: "10:40", timeEnd: "11:30", courseCode: "CSE 3209", courseName: "Artificial Intelligence", teacherInitials: ["WIS"], isLab: false, groupInfo: nil),
                ClassSlot(id: "a-mon-5", period: 5, duration: 1, timeStart: "11:30", timeEnd: "12:20", courseCode: "CSE 3217", courseName: "Mobile Computing", teacherInitials: ["KFI"], isLab: false, groupInfo: nil),
                ClassSlot(id: "a-mon-6", period: 6, duration: 1, timeStart: "12:20", timeEnd: "01:10", courseCode: "HUM 3247", courseName: "Engineers and Society", teacherInitials: ["MMA", "SSA"], isLab: false, groupInfo: nil),
                // Lab Block (A1: Technical Writing, A2: Compiler Lab)
                ClassSlot(id: "a-mon-lab-a1", period: 7, duration: 3, timeStart: "02:30", timeEnd: "05:00", courseCode: "CSE 3230", courseName: "Technical Writing and Seminar", teacherInitials: ["AH", "KSA"], isLab: true, groupInfo: "A1"),
                ClassSlot(id: "a-mon-lab-a2", period: 7, duration: 3, timeStart: "02:30", timeEnd: "05:00", courseCode: "CSE 3212", courseName: "Compiler Design Laboratory", teacherInitials: ["BS", "SN"], isLab: true, groupInfo: "A2")
            ]),
            
            DaySchedule(id: "a-tue", day: "Tuesday", slots: [
                ClassSlot(id: "a-tue-4", period: 4, duration: 1, timeStart: "10:40", timeEnd: "11:30", courseCode: "CSE 3217", courseName: "Mobile Computing", teacherInitials: ["KFI", "LBM"], isLab: false, groupInfo: nil),
                ClassSlot(id: "a-tue-5", period: 5, duration: 1, timeStart: "11:30", timeEnd: "12:20", courseCode: "CSE 3219", courseName: "Software Engineering and Project Management", teacherInitials: ["NFS"], isLab: false, groupInfo: nil),
                ClassSlot(id: "a-tue-6", period: 6, duration: 1, timeStart: "12:20", timeEnd: "01:10", courseCode: "CSE 3209", courseName: "Artificial Intelligence", teacherInitials: ["MMA"], isLab: false, groupInfo: nil),
                // Technical Writing Period 7 (A2)
                ClassSlot(id: "a-tue-7", period: 7, duration: 1, timeStart: "02:30", timeEnd: "03:20", courseCode: "CSE 3210", courseName: "Artificial Intelligence Laboratory", teacherInitials: ["MHO", "WIS"], isLab: true, groupInfo: "A2")
            ]),
            
            DaySchedule(id: "a-wed", day: "Wednesday", slots: [
                ClassSlot(id: "a-wed-1", period: 1, duration: 1, timeStart: "08:00", timeEnd: "08:50", courseCode: "CSE 3219", courseName: "Software Engineering and Project Management", teacherInitials: ["NFS", "EK"], isLab: false, groupInfo: nil),
                ClassSlot(id: "a-wed-2", period: 2, duration: 1, timeStart: "08:50", timeEnd: "09:40", courseCode: "CSE 3211", courseName: "Compiler Design", teacherInitials: ["BS"], isLab: false, groupInfo: nil),
                ClassSlot(id: "a-wed-3", period: 3, duration: 1, timeStart: "09:40", timeEnd: "10:30", courseCode: "HUM 3247", courseName: "Engineers and Society", teacherInitials: ["MMA"], isLab: false, groupInfo: nil),
                // AI Lab (A1)
                ClassSlot(id: "a-wed-lab-a1", period: 4, duration: 3, timeStart: "10:40", timeEnd: "01:10", courseCode: "CSE 3210", courseName: "Artificial Intelligence Laboratory", teacherInitials: ["MHO", "WIS"], isLab: true, groupInfo: "A1")
            ]),
            
            DaySchedule(id: "a-thu", day: "Thursday", slots: [
                ClassSlot(id: "a-thu-3", period: 3, duration: 1, timeStart: "09:40", timeEnd: "10:30", courseCode: "CSE 3211", courseName: "Compiler Design", teacherInitials: ["AH", "BS"], isLab: false, groupInfo: nil),
                ClassSlot(id: "a-thu-4", period: 4, duration: 1, timeStart: "10:40", timeEnd: "11:30", courseCode: "CSE 3209", courseName: "Artificial Intelligence", teacherInitials: ["MMA", "WIS"], isLab: false, groupInfo: nil),
                ClassSlot(id: "a-thu-5", period: 5, duration: 1, timeStart: "11:30", timeEnd: "12:20", courseCode: "HUM 3247", courseName: "Engineers and Society", teacherInitials: ["SSA"], isLab: false, groupInfo: nil),
                // System Development Project
                ClassSlot(id: "a-thu-proj", period: 7, duration: 3, timeStart: "02:30", timeEnd: "05:00", courseCode: "CSE 3200", courseName: "System Development Project", teacherInitials: [], isLab: true, groupInfo: nil)
            ])
        ]
    )
    
    // MARK: - SEC B
    static let secB = RoutineSection(
        id: "sec-b",
        name: "SEC-B",
        roomInfo: "Theory: 306, 402, Lab: Multiple",
        schedule: [
            DaySchedule(id: "b-sun", day: "Sunday", slots: [
                ClassSlot(id: "b-sun-4", period: 4, duration: 1, timeStart: "10:40", timeEnd: "11:30", courseCode: "CSE 3219", courseName: "Software Engineering", teacherInitials: ["EK"], isLab: false, groupInfo: nil),
                ClassSlot(id: "b-sun-5", period: 5, duration: 1, timeStart: "11:30", timeEnd: "12:20", courseCode: "CSE 3211", courseName: "Compiler Design", teacherInitials: ["AH"], isLab: false, groupInfo: nil),
                ClassSlot(id: "b-sun-6", period: 6, duration: 1, timeStart: "12:20", timeEnd: "01:10", courseCode: "CSE 3217", courseName: "Mobile Computing", teacherInitials: ["LBM"], isLab: false, groupInfo: nil),
                // AI Lab (B2)
                ClassSlot(id: "b-sun-lab-b2", period: 7, duration: 3, timeStart: "02:30", timeEnd: "05:00", courseCode: "CSE 3210", courseName: "Artificial Intelligence Laboratory", teacherInitials: ["MHO", "WIS"], isLab: true, groupInfo: "B2")
            ]),
            
            DaySchedule(id: "b-mon", day: "Monday", slots: [
                ClassSlot(id: "b-mon-1", period: 1, duration: 1, timeStart: "08:00", timeEnd: "08:50", courseCode: "CSE 3217", courseName: "Mobile Computing", teacherInitials: ["KFI"], isLab: false, groupInfo: nil),
                ClassSlot(id: "b-mon-2", period: 2, duration: 1, timeStart: "08:50", timeEnd: "09:40", courseCode: "CSE 3209", courseName: "Artificial Intelligence", teacherInitials: ["WIS"], isLab: false, groupInfo: nil),
                ClassSlot(id: "b-mon-3", period: 3, duration: 1, timeStart: "09:40", timeEnd: "10:30", courseCode: "HUM 3247", courseName: "Engineers and Society", teacherInitials: ["MMA", "SSA"], isLab: false, groupInfo: nil),
                // Lab Block (B1: Compiler Lab, B2: SE Lab)
                ClassSlot(id: "b-mon-lab-b1", period: 4, duration: 3, timeStart: "10:40", timeEnd: "01:10", courseCode: "CSE 3212", courseName: "Compiler Design Laboratory", teacherInitials: ["BS", "SN"], isLab: true, groupInfo: "B1"),
                ClassSlot(id: "b-mon-lab-b2", period: 4, duration: 3, timeStart: "10:40", timeEnd: "01:10", courseCode: "CSE 3220", courseName: "Software Engineering and Project Management Laboratory", teacherInitials: ["SA", "NFS"], isLab: true, groupInfo: "B2")
            ]),
            
            DaySchedule(id: "b-tue", day: "Tuesday", slots: [
                ClassSlot(id: "b-tue-1", period: 1, duration: 1, timeStart: "08:00", timeEnd: "08:50", courseCode: "CSE 3217", courseName: "Mobile Computing", teacherInitials: ["KFI", "LBM"], isLab: false, groupInfo: nil),
                ClassSlot(id: "b-tue-2", period: 2, duration: 1, timeStart: "08:50", timeEnd: "09:40", courseCode: "CSE 3219", courseName: "Software Engineering", teacherInitials: ["NFS"], isLab: false, groupInfo: nil),
                ClassSlot(id: "b-tue-3", period: 3, duration: 1, timeStart: "09:40", timeEnd: "10:30", courseCode: "CSE 3209", courseName: "Artificial Intelligence", teacherInitials: ["MMA"], isLab: false, groupInfo: nil),
                // AI Lab (B1)
                ClassSlot(id: "b-tue-lab-b1", period: 4, duration: 3, timeStart: "10:40", timeEnd: "01:10", courseCode: "CSE 3210", courseName: "Artificial Intelligence Laboratory", teacherInitials: ["MHO", "WIS"], isLab: true, groupInfo: "B1")
            ]),
            
            DaySchedule(id: "b-wed", day: "Wednesday", slots: [
                // Lab Block (B2: Mobile Lab, B1: Mobile Lab) - Note: image shows CSE 3218 (B2/B1)
                ClassSlot(id: "b-wed-lab-b2", period: 1, duration: 3, timeStart: "08:00", timeEnd: "10:30", courseCode: "CSE 3218", courseName: "Mobile Computing Laboratory", teacherInitials: ["MRI", "KFI"], isLab: true, groupInfo: "B2"),
                ClassSlot(id: "b-wed-4", period: 4, duration: 1, timeStart: "10:40", timeEnd: "11:30", courseCode: "CSE 3219", courseName: "Software Engineering", teacherInitials: ["NFS", "EK"], isLab: false, groupInfo: nil),
                ClassSlot(id: "b-wed-5", period: 5, duration: 1, timeStart: "11:30", timeEnd: "12:20", courseCode: "CSE 3211", courseName: "Compiler Design", teacherInitials: ["BS"], isLab: false, groupInfo: nil),
                ClassSlot(id: "b-wed-6", period: 6, duration: 1, timeStart: "12:20", timeEnd: "01:10", courseCode: "HUM 3247", courseName: "Engineers and Society", teacherInitials: ["MMA"], isLab: false, groupInfo: nil),
                // Technical Writing Lab (B1/B2)
                ClassSlot(id: "b-wed-lab-tw", period: 7, duration: 3, timeStart: "02:30", timeEnd: "05:00", courseCode: "CSE 3230", courseName: "Technical Writing and Seminar", teacherInitials: ["AH", "KSA"], isLab: true, groupInfo: "B1")
            ]),
            
            DaySchedule(id: "b-thu", day: "Thursday", slots: [
                ClassSlot(id: "b-thu-4", period: 4, duration: 1, timeStart: "10:40", timeEnd: "11:30", courseCode: "HUM 3247", courseName: "Engineers and Society", teacherInitials: ["SSA"], isLab: false, groupInfo: nil),
                ClassSlot(id: "b-thu-5", period: 5, duration: 1, timeStart: "11:30", timeEnd: "12:20", courseCode: "CSE 3211", courseName: "Compiler Design", teacherInitials: ["AH", "BS"], isLab: false, groupInfo: nil),
                ClassSlot(id: "b-thu-6", period: 6, duration: 1, timeStart: "12:20", timeEnd: "01:10", courseCode: "CSE 3209", courseName: "Artificial Intelligence", teacherInitials: ["MMA", "WIS"], isLab: false, groupInfo: nil),
                // System Development Project
                ClassSlot(id: "b-thu-proj", period: 7, duration: 3, timeStart: "02:30", timeEnd: "05:00", courseCode: "CSE 3200", courseName: "System Development Project", teacherInitials: [], isLab: true, groupInfo: nil)
            ])
        ]
    )
}
