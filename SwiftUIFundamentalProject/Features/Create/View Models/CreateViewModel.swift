//
//  CreateViewModel.swift
//  SwiftUIFundamentalProject
//
//  Created by Panachai Sulsaksakul on 10/1/24.
//

import Foundation

final class CreateViewModel: ObservableObject {
    @Published var person = NewPerson()
    @Published private(set) var state: SubmissionState?
    @Published private(set) var error: FormError?
    @Published var hasError = false
    
    private var validator = CreateValidator()
    
    // MARK: - Async Await
    @MainActor
    func createPerson() async {
        do {
            try validator.validate(person)
            
            self.state = .submitting
            
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            let data = try encoder.encode(person)
            
            try await NetworkingManager.shared.request(.create(submissionData: data))
            
            self.state = .successful
        } catch {
            self.hasError = true
            self.state = .unsuccessful
            
            switch error {
            case is NetworkingManager.NetworkingError:
                self.error = .networking(error: error as! NetworkingManager.NetworkingError)
            case is CreateValidator.CreateValidatorError:
                self.error = .validation(error: error as! CreateValidator.CreateValidatorError)
            default:
                self.error = .system(error: error)
            }
        }
    }
    
    // MARK: - Closure
//    func createPerson() {
//        
//        do {
//            try validator.validate(person)
//            
//            state = .submitting
//            
//            let encoder = JSONEncoder()
//            encoder.keyEncodingStrategy = .convertToSnakeCase
//            let data = try? encoder.encode(person)
//            
//            NetworkingManager.shared.request(methodType: .POST(data: data), "https://reqres.in/api/users") { [weak self] result in
//                // Move to main thread for UI updates
//                DispatchQueue.main.async {
//                    switch result {
//                    case .success:
//                        self?.state = .successful
//                    case .failure(let error):
//                        self?.state = .unsuccessful
//                        self?.hasError = true
//                        
//                        if let networkingError = error as? NetworkingManager.NetworkingError {
//                            self?.error = .networking(error: networkingError)
//                        }
//                    }
//                }
//            }
//        } catch {
//            self.hasError = true
//            if let validationError = error as? CreateValidator.CreateValidatorError {
//                self.error = .validation(error: validationError)
//            }
//        }
//    }
}

extension CreateViewModel {
    enum SubmissionState {
        case unsuccessful
        case successful
        case submitting
    }
}

extension CreateViewModel {
    enum FormError: LocalizedError {
        case networking(error: LocalizedError)
        case validation(error: LocalizedError)
        case system(error: Error)
    }
}

extension CreateViewModel.FormError {
    var errorDescription: String? {
        switch self {
        case .networking(let error),
                .validation(error: let error):
            return error.errorDescription
        case .system(error: let err):
            return err.localizedDescription
        }
    }
}
