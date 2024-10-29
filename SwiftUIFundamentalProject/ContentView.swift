//
//  ContentView.swift
//  SwiftUIFundamentalProject
//
//  Created by Panachai Sulsaksakul on 9/4/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
        }
        .onAppear() {
            print("✅ UserResponse")
            dump (
                try? StaticJSONMapper.decode(file: "UsersStaticData", type: UsersResponse.self)
            )
            
            print("✅ UserDetailsResponse")
            dump (
                try? StaticJSONMapper.decode(file: "SingleUserData", type: UserDetailsResponse.self)
            )
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
