//
//  UserResponse.swift
//  SwiftUIFundamentalProject
//
//  Created by Panachai Sulsaksakul on 9/26/24.
//

// MARK: - UserResponse
struct UsersResponse: Codable {
    let page, perPage, total, totalPages: Int
    let data: [User]
    let support: Support
}
