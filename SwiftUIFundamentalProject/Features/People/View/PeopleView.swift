//
//  PeopleView.swift
//  SwiftUIFundamentalProject
//
//  Created by Panachai Sulsaksakul on 9/28/24.
//

import SwiftUI

struct PeopleView: View {
    private let columns = Array(repeating: GridItem(.flexible()), count: 2)
    
    @StateObject private var vm = PeopleViewModel()
    
    @State private var users: [User] = []
    @State private var showCreateView: Bool = false
    @State private var shouldShowSuccess: Bool = false
    @State private var hasAppeared: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                background
                
                if vm.isLoading {
                    ProgressView()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            // User has their own id, so no need to conform to Identifiable protocol
                            ForEach(vm.users, id: \.id) { user in
                                NavigationLink {
                                    DetailView(userId: user.id)
                                } label: {
                                    PeopleItemView(user: user)
                                        .task {
                                            if vm.hasReachedEnd(of: user) {
                                                await vm.fetchNextSetOfUsers()
                                            }
                                        }
                                }
                            }
                        }
                        .padding()
                        .overlay(alignment: .bottom) {
                            if vm.isFetching {
                                ProgressView()
                            }
                        }
                    }
                }
            }
            .navigationTitle("People")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    createNewPerson
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    refreshData
                }
            }
            // use .task when working with onAppear() or onDisappear()
            .task {
                if hasAppeared == false {
                    await vm.fetchUser()
                    hasAppeared.toggle()
                }
            }
//            .onAppear() {
//                vm.fetchUser()
//                // Dummy json data
//                do {
//                    let res = try StaticJSONMapper.decode(file: "UsersStaticData", type: UsersResponse.self)
//
//                    users = res.data
//                    print(users)
//                } catch {
//                    print("can't load data from JSON file \(error)")
//                }
//            }
            .sheet(isPresented: $showCreateView) {
                CreateView {
                    haptic(.success)
                    withAnimation(.spring().delay(0.25)) {
                        self.shouldShowSuccess.toggle() 
                    }
                }
            }
            .alert(isPresented: $vm.hasError,
                   error: vm.error) {
                Button {
                    // use Task when working with label
                    Task {
                        await vm.fetchUser()
                    }
                } label: {
                    Text("Retry")
                }
            }
            .overlay {
                if shouldShowSuccess {
                    CheckmarkPopoverView()
                        // Add fade in and out animation
                        .transition(.scale.combined(with: .opacity))
                        // Delay 1.5 seconds then display the popover view
                        .onAppear() {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                withAnimation(.spring()) {
                                    self.shouldShowSuccess.toggle()
                                }
                            }
                        }
                }
            }
        }
    }
}

#Preview {
    PeopleView()
}

extension PeopleView {
    var background: some View {
        Theme.background
            .ignoresSafeArea(edges: .top)
    }
    var createNewPerson: some View {
        Button {
            showCreateView.toggle()
        } label: {
            Symbols.plus
                .font(
                    .system(.headline, design: .rounded)
                    .bold()
                )
                .tint(.black)
        }
    }
    
    var refreshData: some View {
        Button {
            Task {
                await vm.fetchUser()
            }
        } label: {
            Symbols.refresh
        }
        .disabled(vm.isLoading)
    }
}
