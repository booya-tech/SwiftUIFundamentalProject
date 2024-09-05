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
            Circle().frame(width: 100)
            
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, Notion!")
            
            Text("Boo Pannachai")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
