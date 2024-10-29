//
//  NetworkingManager.swift
//  SwiftUIFundamentalProject
//
//  Created by Panachai Sulsaksakul on 9/30/24.
//

import Foundation

// MARK: - Handle with Endpoint
// marked as final means can't be overidden or subclassed by Class or Struct
final class NetworkingManager {
    // Singleton
    static let shared = NetworkingManager()
    
    private init() {}
    
    // MARK: - Swift Concurrency
    func request<T: Codable>(endpoint: Endpoint,
                             type: T.Type) async throws -> T {
        guard let url = endpoint.url else {
            throw NetworkingError.invalidURL
        }
        
        let request = buildRequest(from: url, methodType: endpoint.methodType)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // 200 to 300 means OK
        guard let response = response as? HTTPURLResponse,
              (200...300) ~= response.statusCode else {
            let statusCode = (response as! HTTPURLResponse).statusCode
            
            throw NetworkingError.invalidResponse(statusCode: statusCode)
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let res = try decoder.decode(T.self, from: data)
        
        return res
    }
    
    // .GET default value
    func request(_ endpoint: Endpoint) async throws {
        guard let url = endpoint.url else {
            throw NetworkingError.invalidURL
        }
        
        let request = buildRequest(from: url, methodType: endpoint.methodType)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        // 200 to 300 means OK
        guard let response = response as? HTTPURLResponse,
              (200...300) ~= response.statusCode else {
            let statusCode = (response as! HTTPURLResponse).statusCode
            
            throw NetworkingError.invalidResponse(statusCode: statusCode)
        }
    }
}

// Custom Handle Error
extension NetworkingManager {
    enum NetworkingError: LocalizedError {
        case invalidURL
        case customError(error: Error)
        case invalidResponse(statusCode: Int)
        case invalidData
        case invalidDecodeJSON(error: Error)
    }
}

extension NetworkingManager.NetworkingError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse(statusCode: let statusCode):
            return "Invalid Response: \(statusCode)"
        case .invalidData:
            return "Invalid Data"
        case .invalidDecodeJSON:
            return "Failed to decode"
        case .customError(let error):
            return "Something went wrong \(error.localizedDescription)"
        }
    }
}

// Mark as private to not expose this outside of NetworkingManager
private extension NetworkingManager {
    func buildRequest(from url: URL, methodType: Endpoint.MethodType) -> URLRequest {
        var request = URLRequest(url: url)

        switch methodType {
        case .GET:
            request.httpMethod = "GET"
        case .POST(let data):
            request.httpMethod = "POST"
            request.httpBody = data
        }
        
        return request
    }
}
    
//    func request<T: Codable>(_ absoluteURL: String,
//                             type: T.Type,
//                             completion: @escaping (Result<T, Error>) -> Void) {
//        guard let url = URL(string: absoluteURL) else {
//            completion(.failure(NetworkingError.invalidURL))
//            
//            return
//        }
//        
//        let request = URLRequest(url: url)
//        
//        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
//            if error != nil {
//                completion(.failure(NetworkingError.customError(error: error!)))
//                return
//            }
//            
//            // 200 to 300 means OK
//            guard let response = response as? HTTPURLResponse,
//                  (200...300) ~= response.statusCode else {
//                let statusCode = (response as! HTTPURLResponse).statusCode
//                completion(.failure(NetworkingError.invalidResponse(statusCode: statusCode)))
//                
//                return
//            }
//            
//            guard let data = data else {
//                return
//            }
//            
//            do {
//                // Decode JSON data and convert snake case -> camel case (Swift style)
//                let decoder = JSONDecoder()
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
//                let res = try decoder.decode(T.self, from: data)
//                
//                completion(.success(res))
//            } catch {
//                completion(.failure(NetworkingError.invalidDecodeJSON(error: error)))
//            }
//        }
//        // Called everytime when working with URLSession to start the networking task
//        dataTask.resume()
//    }
    
// MARK: - New Request support both .POST and .GET
// .GET default value
//    func request<T: Codable>(endpoint: Endpoint,
//                             type: T.Type,
//                             completion: @escaping (Result<T, Error>) -> Void) {
//        guard let url = endpoint.url else {
//            completion(.failure(NetworkingError.invalidURL))
//            
//            return
//        }
//        
//        let request = buildRequest(from: url, methodType: endpoint.methodType)
//        
//        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
//            if error != nil {
//                completion(.failure(NetworkingError.customError(error: error!)))
//                return
//            }
//            
//            // 200 to 300 means OK
//            guard let response = response as? HTTPURLResponse,
//               (200...300) ~= response.statusCode else {
//                let statusCode = (response as! HTTPURLResponse).statusCode
//                completion(.failure(NetworkingError.invalidResponse(statusCode: statusCode)))
//                
//                return
//            }
//            
//            guard let data = data else {
//                return
//            }
//            
//            do {
//                // Decode JSON data and convert snake case -> camel case (Swift style)
//                let decoder = JSONDecoder()
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
//                let res = try decoder.decode(T.self, from: data)
//                
//                completion(.success(res))
//            } catch {
//                completion(.failure(NetworkingError.invalidDecodeJSON(error: error)))
//            }
//        }
//        // Called everytime when working with URLSession to start the networking task
//        dataTask.resume()
//    }
//    
//    // .GET default value
//    func request(endpoint: Endpoint,
//                 completion: @escaping (Result<Void, Error>) -> Void) {
//        guard let url = endpoint.url else {
//            completion(.failure(NetworkingError.invalidURL))
//            
//            return
//        }
//        
//        let request = buildRequest(from: url, methodType: endpoint.methodType)
//        
//        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
//            if error != nil {
//                completion(.failure(NetworkingError.customError(error: error!)))
//                return
//            }
//            
//            // 200 to 300 means OK
//            guard let response = response as? HTTPURLResponse,
//               (200...300) ~= response.statusCode else {
//                let statusCode = (response as! HTTPURLResponse).statusCode
//                completion(.failure(NetworkingError.invalidResponse(statusCode: statusCode)))
//                
//                return
//            }
//            
//            completion(.success(()))
//        }
//        // Called everytime when working with URLSession to start the networking task
//        dataTask.resume()
//    }
//    
// MARK: - Old Request not support .POST only .GET
//     Using Generics to handle any type of data
//    func request<T: Codable>(_ absoluteURL: String,
//                             type: T.Type,
//                             completion: @escaping (Result<T, Error>) -> Void) {
//        guard let url = URL(string: absoluteURL) else {
//            completion(.failure(NetworkingError.invalidURL))
//
//            return
//        }
//
//        let request = URLRequest(url: url)
//
//        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
//            if error != nil {
//                completion(.failure(NetworkingError.customError(error: error!)))
//                return
//            }
//
//            // 200 to 300 means OK
//            guard let response = response as? HTTPURLResponse,
//               (200...300) ~= response.statusCode else {
//                let statusCode = (response as! HTTPURLResponse).statusCode
//                completion(.failure(NetworkingError.invalidResponse(statusCode: statusCode)))
//
//                return
//            }
//
//            guard let data = data else {
//                return
//            }
//
//            do {
//                // Decode JSON data and convert snake case -> camel case (Swift style)
//                let decoder = JSONDecoder()
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
//                let res = try decoder.decode(T.self, from: data)
//
//                completion(.success(res))
//            } catch {
//                completion(.failure(NetworkingError.invalidDecodeJSON(error: error)))
//            }
//        }
//        // Called everytime when working with URLSession to start the networking task
//        dataTask.resume()
//    }
//}

// MARK: - Old NetworkingManager without handle with Endpoint
//final class NetworkingManager {
//    // Singleton
//    static let shared = NetworkingManager()
//    
//    private init() {}
//    
//    // MARK: - New Request support both .POST and .GET
//    // .GET default value
//    func request<T: Codable>(methodType: MethodType = .GET,
//                             _ absoluteURL: String,
//                             type: T.Type,
//                             completion: @escaping (Result<T, Error>) -> Void) {
//        guard let url = URL(string: absoluteURL) else {
//            completion(.failure(NetworkingError.invalidURL))
//            
//            return
//        }
//        
//        let request = buildRequest(from: url, methodType: methodType)
//        
//        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
//            if error != nil {
//                completion(.failure(NetworkingError.customError(error: error!)))
//                return
//            }
//            
//            // 200 to 300 means OK
//            guard let response = response as? HTTPURLResponse,
//               (200...300) ~= response.statusCode else {
//                let statusCode = (response as! HTTPURLResponse).statusCode
//                completion(.failure(NetworkingError.invalidResponse(statusCode: statusCode)))
//                
//                return
//            }
//            
//            guard let data = data else {
//                return
//            }
//            
//            do {
//                // Decode JSON data and convert snake case -> camel case (Swift style)
//                let decoder = JSONDecoder()
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
//                let res = try decoder.decode(T.self, from: data)
//                
//                completion(.success(res))
//            } catch {
//                completion(.failure(NetworkingError.invalidDecodeJSON(error: error)))
//            }
//        }
//        // Called everytime when working with URLSession to start the networking task
//        dataTask.resume()
//    }
//    
//    // .GET default value
//    func request(methodType: MethodType = .GET,
//                             _ absoluteURL: String,
//                             completion: @escaping (Result<Void, Error>) -> Void) {
//        guard let url = URL(string: absoluteURL) else {
//            completion(.failure(NetworkingError.invalidURL))
//            
//            return
//        }
//        
//        let request = buildRequest(from: url, methodType: methodType)
//        
//        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
//            if error != nil {
//                completion(.failure(NetworkingError.customError(error: error!)))
//                return
//            }
//            
//            // 200 to 300 means OK
//            guard let response = response as? HTTPURLResponse,
//               (200...300) ~= response.statusCode else {
//                let statusCode = (response as! HTTPURLResponse).statusCode
//                completion(.failure(NetworkingError.invalidResponse(statusCode: statusCode)))
//                
//                return
//            }
//            
//            completion(.success(()))
//        }
//        // Called everytime when working with URLSession to start the networking task
//        dataTask.resume()
//    }
//    // MARK: - Old Request not support .POST only .GET
//    // Using Generics to handle any type of data
////    func request<T: Codable>(_ absoluteURL: String,
////                             type: T.Type,
////                             completion: @escaping (Result<T, Error>) -> Void) {
////        guard let url = URL(string: absoluteURL) else {
////            completion(.failure(NetworkingError.invalidURL))
////
////            return
////        }
////
////        let request = URLRequest(url: url)
////
////        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
////            if error != nil {
////                completion(.failure(NetworkingError.customError(error: error!)))
////                return
////            }
////
////            // 200 to 300 means OK
////            guard let response = response as? HTTPURLResponse,
////               (200...300) ~= response.statusCode else {
////                let statusCode = (response as! HTTPURLResponse).statusCode
////                completion(.failure(NetworkingError.invalidResponse(statusCode: statusCode)))
////
////                return
////            }
////
////            guard let data = data else {
////                return
////            }
////
////            do {
////                // Decode JSON data and convert snake case -> camel case (Swift style)
////                let decoder = JSONDecoder()
////                decoder.keyDecodingStrategy = .convertFromSnakeCase
////                let res = try decoder.decode(T.self, from: data)
////
////                completion(.success(res))
////            } catch {
////                completion(.failure(NetworkingError.invalidDecodeJSON(error: error)))
////            }
////        }
////        // Called everytime when working with URLSession to start the networking task
////        dataTask.resume()
////    }
//}
