//
//  DetailView.swift
//  SwiftUIFundamentalProject
//
//  Created by Panachai Sulsaksakul on 9/30/24.
//

import SwiftUI

struct DetailView: View {
    let userId: Int
    @StateObject private var vm = DetailViewModel()
//    @State private var userInfo: UserDetailsResponse?
    
    var body: some View {
        ZStack {
            background
            
            if vm.isLoading {
                ProgressView()
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        avatar
                        
                        Group {
                            general
                            link
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 18)
                        .background(Theme.detailBackground, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Details")
        .task {
            await vm.fetchUserInfo(id: userId)
        }
        .alert(isPresented: $vm.hasError,
               error: vm.error) {
            Button {
                Task {
                    await vm.fetchUserInfo(id: userId)
                }
            } label: {
                Text("Retry")
            }
        }
    }
}

#Preview {
    var previewUserId: Int {
        let users = try! StaticJSONMapper.decode(file: "UsersStaticData", type: UsersResponse.self)
        
        return users.data.first!.id
    }
    
    DetailView(userId: previewUserId)
}

extension DetailView {
    var background: some View {
        Theme.background
            .ignoresSafeArea(edges: .top)
    }
    
    @ViewBuilder
    var avatar: some View {
        if let avatarAbsoluteString = vm.userInfo?.data.avatar,
           let avatarSupportURL = URL(string: avatarAbsoluteString) {
            AsyncImage(url: avatarSupportURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 250)
                    .clipped()
            } placeholder: {
                ProgressView()
            }
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
    }
    
    var general: some View {
        VStack(alignment: .leading, spacing: 8) {
            PillView(id: userId)
            
            // General Details
            Group {
                firstname
                lastname
                email
            }
            .foregroundStyle(Theme.text)
        }
    }
    
    @ViewBuilder
    var firstname: some View {
        Text("First Name")
            .font(.system(.body, design: .rounded))
            .fontWeight(.bold)
        Text("\(vm.userInfo?.data.firstName ?? "-")")
            .font(.system(.subheadline, design: .rounded))
        Divider()
    }
    
    @ViewBuilder
    var lastname: some View {
        Text("Last Name")
            .font(.system(.body, design: .rounded))
            .fontWeight(.bold)
        Text("\(vm.userInfo?.data.lastName ?? "-")")
            .font(.system(.subheadline, design: .rounded))
        Divider()
    }
    
    @ViewBuilder
    var email: some View {
        Text("Email")
            .font(.system(.body, design: .rounded))
            .fontWeight(.bold)
        Text("\(vm.userInfo?.data.email ?? "-")")
            .font(.system(.subheadline, design: .rounded))
    }
    
    @ViewBuilder
    var link: some View {
        if let supportAbsoluteString = vm.userInfo?.support.url,
           let supportURL = URL(string: supportAbsoluteString),
           let supportTxt = vm.userInfo?.support.text {
            Link(destination: supportURL) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(supportTxt)")
                        .foregroundStyle(Theme.text)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                    
                    Text("\(supportAbsoluteString)")
                    
                }
                Spacer()
                Symbols.link
            }
        }
    }
}
