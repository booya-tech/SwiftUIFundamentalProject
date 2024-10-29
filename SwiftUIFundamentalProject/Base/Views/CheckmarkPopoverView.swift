//
//  CheckmarkPopoverView.swift
//  SwiftUIFundamentalProject
//
//  Created by Panachai Sulsaksakul on 10/2/24.
//

import SwiftUI

struct CheckmarkPopoverView: View {
    var body: some View {
        Symbols.checkmark
            .font(.system(.largeTitle,
                          design: .rounded).bold())
            .padding()
            .background(Color(.green),
                        in: RoundedRectangle(
                            cornerRadius: 10,
                            style: .continuous)
            )
            .foregroundStyle(.white)
        
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    CheckmarkPopoverView()
        .padding()
}
