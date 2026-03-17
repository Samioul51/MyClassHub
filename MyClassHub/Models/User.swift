//
//  User.swift
//  MyClassHub
//
//  Created by SIR on 16/3/26.
//

import Foundation

enum UserRole: String, Codable {
    case admin = "admin"
    case user = "user"
}

struct AppUser: Identifiable, Codable {
    var id: String          // Firebase UID
    var name: String
    var email: String
    var roll: String
    var role: UserRole
}
