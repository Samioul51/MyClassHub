//
//  TeacherService.swift
//  MyClassHub
//
//  Created by SIR on 16/3/26.
//

import FirebaseFirestore

class TeacherService {
    static let shared = TeacherService()
    private let db = Firestore.firestore()

    func fetchTeachers() async throws -> [Teacher] {
        let snapshot = try await db.collection("teachers")
            .order(by: "name")
            .getDocuments()

        return snapshot.documents.map { doc in
            let data = doc.data()
            return Teacher(
                id: doc.documentID,
                name: data["name"] as? String ?? "",
                designation: data["designation"] as? String ?? "",
                email: data["email"] as? String ?? "",
                image: data["image"] as? String ?? "",
                phone: data["phone"] as? String
            )
        }
    }
}
