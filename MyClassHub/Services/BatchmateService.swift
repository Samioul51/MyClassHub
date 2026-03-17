//
//  BatchmateService.swift
//  MyClassHub
//
//  Created by SIR on 16/3/26.
//

import FirebaseFirestore

class BatchmateService {
    static let shared = BatchmateService()
    private let db = Firestore.firestore()

    func fetchBatchmates() async throws -> [Batchmate] {
        let snapshot = try await db.collection("batchmates")
            .order(by: "roll")
            .getDocuments()

        return snapshot.documents.map { doc in
            let data = doc.data()
            return Batchmate(
                id: doc.documentID,
                roll: data["roll"] as? String ?? "",
                name: data["name"] as? String ?? "",
                college: data["college"] as? String ?? "",
                homeDistrict: data["homeDistrict"] as? String ?? "",
                bloodGroup: data["bloodGroup"] as? String ?? "",
                contactNumber: data["contactNumber"] as? String,
                image: data["image"] as? String
            )
        }
    }

    // Admin add function
    
    func addBatchmate(_ batchmate: Batchmate) async throws {
        try await db.collection("batchmates").document(batchmate.id).setData([
            "roll": batchmate.roll,
            "name": batchmate.name,
            "college": batchmate.college,
            "homeDistrict": batchmate.homeDistrict,
            "bloodGroup": batchmate.bloodGroup,
            "contactNumber": batchmate.contactNumber ?? "",
            "image": batchmate.image ?? ""
        ])
    }

    // Admin update function
    
    func updateBatchmate(_ batchmate: Batchmate) async throws {
        try await db.collection("batchmates").document(batchmate.id).updateData([
            "roll": batchmate.roll,
            "name": batchmate.name,
            "college": batchmate.college,
            "homeDistrict": batchmate.homeDistrict,
            "bloodGroup": batchmate.bloodGroup,
            "contactNumber": batchmate.contactNumber ?? "",
            "image": batchmate.image ?? ""
        ])
    }

    // Admin delete function
    
    func deleteBatchmate(id: String) async throws {
        try await db.collection("batchmates").document(id).delete()
    }
}
