//
//  SwiftUIFundamentalProjectApp.swift
//  SwiftUIFundamentalProject
//
//  Created by Panachai Sulsaksakul on 9/4/24.
//

import SwiftUI

@main
struct SwiftUIFundamentalProjectApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                PeopleView()
                    .tabItem {
                        Symbols.person
                        Text("Home")
                    }
                SettingsView()
                    .tabItem {
                        Symbols.gear
                        Text("Settings")
                    }
            }
        }
    }
}
