//
//  Models.swift
//  SwiftUIFundamentalProject
//
//  Created by Panachai Sulsaksakul on 9/26/24.
//

import Foundation

// MARK: - DataClass
struct User: Codable {
    let id: Int
    let email, firstName, lastName: String
    let avatar: String
}

// MARK: - Support
struct Support: Codable {
    let url: String
    let text: String
}
