//
//  Symbols.swift
//  SwiftUIFundamentalProject
//
//  Created by Panachai Sulsaksakul on 9/4/24.
//

import Foundation
import SwiftUI

// Use enum instead of Struct due to enum can't use initializer likes Struct does.
enum Symbols {
    static let person = Image(systemName: "person.2")
    static let gear = Image(systemName: "gear")
    static let plus = Image(systemName: "plus")
    static let link = Image(systemName: "link")
    static let checkmark = Image(systemName: "checkmark")
    static let refresh = Image(systemName: "arrow.clockwise")
}
