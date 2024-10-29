//
//  Person.swift
//  SwiftUIFundamentalProject
//
//  Created by Panachai Sulsaksakul on 10/1/24.
//

import Foundation

// Create Model to encode the data then send back to server
struct NewPerson: Codable {
    var firstName: String = ""
    var lastName: String = ""
    var job: String = ""
}
