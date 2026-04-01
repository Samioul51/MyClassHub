//
//  RoutineService.swift
//  MyClassHub
//
//  Created by AI on 16/3/26.
//

import FirebaseFirestore

class RoutineService {
    static let shared = RoutineService()
    private let db = Firestore.firestore()

    func fetchRoutine(year: String, term: String) async throws -> ClassRoutine? {
        let snapshot = try await db.collection("routines")
            .whereField("year", isEqualTo: year)
            .whereField("term", isEqualTo: term)
            .limit(to: 1)
            .getDocuments()

        guard let doc = snapshot.documents.first else { return nil }
        return decodeRoutine(doc)
    }

    // MARK: - DECODE (reuse same logic)

    private func decodeRoutine(_ doc: QueryDocumentSnapshot) -> ClassRoutine {
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
