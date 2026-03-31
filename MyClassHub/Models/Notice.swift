//
//  Notice.swift
//  MyClassHub
//
//  Created by AI on 31/3/26.
//

import Foundation
import FirebaseFirestore

struct Notice: Identifiable, Codable {
    @DocumentID var id: String?
    let title: String
    let description: String
    let date: Date
    let category: NoticeCategory
    
    // Metadata for Assessments (CT, Lab Test, Quiz, Viva, etc.)
    var location: String? // Classroom or Lab
    var time: String?
    var syllabus: String?
    var deadline: Date? // Useful for Projects
}

enum NoticeCategory: String, Codable, CaseIterable {
    case general = "General"
    case ct = "Class Test"
    case labTest = "Lab Test"
    case quiz = "Quiz"
    case project = "Project"
    case viva = "Viva"
    
    // Helper to identify if we should show the "Logistics" UI
    var isAssessment: Bool {
        return self != .general && self != .project
    }
    
    var icon: String {
        switch self {
        case .general: return "megaphone.fill"
        case .ct: return "doc.text.fill"
        case .labTest: return "testtube.2"
        case .quiz: return "checkmark.seal.fill"
        case .project: return "folder.fill"
        case .viva: return "person.wave.2.fill"
        }
    }
}
