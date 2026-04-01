//
//  AdminRoutineService.swift
//  MyClassHub
//
//  Created by AI on 31/3/26.
//

import FirebaseFirestore

class AdminRoutineService {
    static let shared = AdminRoutineService()
    private let db = Firestore.firestore()

    // MARK: - SAVE

    func saveRoutine(_ routine: ClassRoutine) async throws {
        let data = encodeRoutine(routine)

        try await db.collection("routines")
            .document(routine.id)
            .setData(data)
    }

    func deleteRoutine(id: String) async throws {
        try await db.collection("routines")
            .document(id)
            .delete()
    }

    func fetchAllRoutines() async throws -> [ClassRoutine] {
        let snapshot = try await db.collection("routines").getDocuments()
        return snapshot.documents.compactMap { decodeRoutine($0) }
    }

    // MARK: - ENCODE

    private func encodeRoutine(_ routine: ClassRoutine) -> [String: Any] {
        return [
            "session": routine.session,
            "year": routine.year,
            "term": routine.term,
            "startDate": routine.startDate,
            "sections": routine.sections.map { encodeSection($0) }
        ]
    }

    private func encodeSection(_ section: RoutineSection) -> [String: Any] {
        return [
            "id": section.id,
            "name": section.name,
            "roomInfo": section.roomInfo,
            "schedule": section.schedule.map { encodeDay($0) }
        ]
    }

    private func encodeDay(_ day: DaySchedule) -> [String: Any] {
        return [
            "id": day.id,
            "day": day.day,
            "slots": day.slots.map { encodeSlot($0) }
        ]
    }

    private func encodeSlot(_ slot: ClassSlot) -> [String: Any] {
        var data: [String: Any] = [
            "id": slot.id,
            "period": slot.period,
            "timeStart": slot.timeStart,
            "timeEnd": slot.timeEnd,
            "courseCode": slot.courseCode,
            "courseName": slot.courseName,
            "teacherInitials": slot.teacherInitials,
            "isLab": slot.isLab
        ]

        if let group = slot.groupInfo {
            data["groupInfo"] = group
        }

        return data
    }

    // MARK: - DECODE

    private func decodeRoutine(_ doc: QueryDocumentSnapshot) -> ClassRoutine? {
        let data = doc.data()
        let sectionsData = data["sections"] as? [[String: Any]] ?? []

        return ClassRoutine(
            id: doc.documentID,
            session: data["session"] as? String ?? "",
            year: data["year"] as? String ?? "",
            term: data["term"] as? String ?? "",
            startDate: data["startDate"] as? String ?? "",
            sections: sectionsData.map { decodeSection($0) }
        )
    }

    private func decodeSection(_ data: [String: Any]) -> RoutineSection {
        let scheduleData = data["schedule"] as? [[String: Any]] ?? []

        return RoutineSection(
            id: data["id"] as? String ?? UUID().uuidString,
            name: data["name"] as? String ?? "",
            roomInfo: data["roomInfo"] as? String ?? "",
            schedule: scheduleData.map { decodeDay($0) }
        )
    }

    private func decodeDay(_ data: [String: Any]) -> DaySchedule {
        let slotsData = data["slots"] as? [[String: Any]] ?? []

        return DaySchedule(
            id: data["id"] as? String ?? UUID().uuidString,
            day: data["day"] as? String ?? "",
            slots: slotsData.map { decodeSlot($0) }
        )
    }

    private func decodeSlot(_ data: [String: Any]) -> ClassSlot {
        return ClassSlot(
            id: data["id"] as? String ?? UUID().uuidString,
            period: data["period"] as? Int ?? 0,
            duration: data["duration"] as? Int ?? 0,
            timeStart: data["timeStart"] as? String ?? "",
            timeEnd: data["timeEnd"] as? String ?? "",
            courseCode: data["courseCode"] as? String ?? "",
            courseName: data["courseName"] as? String ?? "",
            teacherInitials: data["teacherInitials"] as? [String] ?? [],
            isLab: data["isLab"] as? Bool ?? false,
            groupInfo: data["groupInfo"] as? String
        )
    }
}
