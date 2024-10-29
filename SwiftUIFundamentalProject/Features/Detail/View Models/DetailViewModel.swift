//
//  DetailViewModel.swift
//  SwiftUIFundamentalProject
//
//  Created by Panachai Sulsaksakul on 10/1/24.
//

import Foundation

class DetailViewModel: ObservableObject {
    @Published private(set) var userInfo: UserDetailsResponse?
    // Custom handle the error
    @Published private(set) var error: NetworkingManager.NetworkingError?
    @Published private(set) var isLoading: Bool = false
    @Published var hasError = false
    
    @MainActor
    func fetchUserInfo(id: Int) async {
        isLoading = true
        // Move back to main thread to handle UI
        do {
            defer { isLoading = false }
            // Called api run in background thread
            let response = try await NetworkingManager.shared.request(endpoint:.detail(id: id), type: UserDetailsResponse.self)
            self.userInfo = response
            
        } catch {
            if let networkingError = error as? NetworkingManager.NetworkingError {
                self.error = networkingError
            } else {
                self.error = .customError(error: error)
            }
        }
    }
}
