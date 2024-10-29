//
//  PeopleViewModel.swift
//  SwiftUIFundamentalProject
//
//  Created by Panachai Sulsaksakul on 9/30/24.
//

import Foundation

// marked as final means can't be overidden or subclassed by Class or Struct
final class PeopleViewModel: ObservableObject {
    // private(set): able to access from outside as view model, but no capability to modify it
    @Published private(set) var users: [User] = []
    // Custom handle the error
    @Published private(set) var error: NetworkingManager.NetworkingError?
    @Published private(set) var viewState: ViewState?
    @Published var hasError = false
    
    private var page = 1
    private var totalPages: Int?
    
    // Computed Property
    var isLoading: Bool {
        viewState == .loading
    }
    
    var isFetching: Bool {
        viewState == .fetching
    }
    
    // MARK: - Async await networking calls
    @MainActor
    func fetchUser() async {
        reset()
        viewState = .loading
        defer { viewState = .finished }
        
        do {
            let response = try await NetworkingManager.shared.request(endpoint: .people(page: page), type: UsersResponse.self)
            self.totalPages = response.totalPages
            self.users = response.data
        } catch {
            self.hasError = true
            
            // downcasting as optional due to the error can exist or not
            if let networkingError = error as? NetworkingManager.NetworkingError {
                self.error = networkingError
            } else {
                self.error = .customError(error: error)
            }
        }
    }
    
    @MainActor
    func fetchNextSetOfUsers() async {
        
        guard page != totalPages else { return }
        
        viewState = .fetching
        defer { viewState = .finished }
        
        page += 1
        
        do {
            let response = try await NetworkingManager.shared.request(endpoint: .people(page: page), type: UsersResponse.self)
            self.totalPages = response.totalPages
            self.users += response.data
        } catch {
            self.hasError = true
            
            // downcasting as optional due to the error can exist or not
            if let networkingError = error as? NetworkingManager.NetworkingError {
                self.error = networkingError
            } else {
                self.error = .customError(error: error)
            }
        }
    }
    
    func hasReachedEnd(of user: User) -> Bool {
        users.last?.id == user.id
    }
    
    // MARK: - Closure networking calls
    // mark as [weak self] when using closure inside the class can cause a ratain cycle
//    func fetchUser() {
//        isLoading = true
//        
//        NetworkingManager.shared.request(.people, type: UsersResponse.self) { [weak self] result in
//            DispatchQueue.main.async {
//                defer { self?.isLoading = false }
//                switch result {
//                case .success(let response):
//                    self?.users = response.data
//                case .failure(let error):
//                    self?.hasError = true
//                    self?.error = error as? NetworkingManager.NetworkingError
//                }
//            }
//        }
//    }
}

extension PeopleViewModel {
    enum ViewState {
        case fetching
        case loading
        case finished
    }
}

private extension PeopleViewModel {
    func reset() {
        if viewState == .finished {
            users.removeAll()
            page = 1
            totalPages = nil
            viewState = nil
        }
    }
}
