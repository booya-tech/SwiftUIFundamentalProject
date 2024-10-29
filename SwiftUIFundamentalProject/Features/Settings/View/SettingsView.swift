//
//  SettingsView.swift
//  SwiftUIFundamentalProject
//
//  Created by Panachai Sulsaksakul on 10/2/24.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage(UserDefaultKeys.isHapticsEnabled) var isHapticsEnabled: Bool = true // Stores a boolean in UserDefaults
    
    var body: some View {
        NavigationView {
            Form {
                haptics
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}

private extension SettingsView {
    var haptics: some View {
        Toggle("Haptics", isOn: $isHapticsEnabled)
    }
}
