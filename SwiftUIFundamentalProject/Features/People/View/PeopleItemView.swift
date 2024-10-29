//
//  PeopleItemView.swift
//  SwiftUIFundamentalProject
//
//  Created by Panachai Sulsaksakul on 9/30/24.
//

import SwiftUI

struct PeopleItemView: View {
    let user: User
    
    var body: some View {
            VStack(spacing: .zero) {
                AsyncImage(url: .init(string: user.avatar)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 130)
                        .clipped()
                } placeholder: {
                    ProgressView()
                }
                
                VStack(alignment: .leading) {
                    PillView(id: user.id)
                    
                    Text("\(user.firstName) \(user.lastName)")
                        .font(
                            .system(.body, design: .rounded)
                        )
                        .foregroundStyle(Theme.text)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 8)
                .padding(.vertical, 5)
                .background(Theme.detailBackground)
            }
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .shadow(
                color: Theme.text.opacity(0.1),
                radius: 10,
                x: 0,
                y: 1
            )
    }
}

#Preview {
    var previewUser: User {
        let users = try! StaticJSONMapper.decode(file: "UsersStaticData", type: UsersResponse.self)
        
        return users.data.first!
    }

    PeopleItemView(user: previewUser)
        .frame(width: 200)
}
