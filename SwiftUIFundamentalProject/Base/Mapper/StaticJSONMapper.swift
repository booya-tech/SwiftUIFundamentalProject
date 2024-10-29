//
//  StaticJSONMapper.swift
//  SwiftUIFundamentalProject
//
//  Created by Panachai Sulsaksakul on 9/26/24.
//

import Foundation

struct StaticJSONMapper {
    static func decode<T: Decodable>(file: String, type: T.Type) throws -> T {
        guard !file.isEmpty,
              let path = Bundle.main.path(forResource: file, ofType: "json"),
              let data = FileManager.default.contents(atPath: path) else {
            
            throw MappingError.failedToGetContents
        }
            
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let result = try decoder .decode(T.self, from: data)
        
        return result
    }
}

extension StaticJSONMapper {
    enum MappingError: Error {
        case failedToGetContents
    }
}
