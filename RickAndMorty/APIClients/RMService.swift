//
//  RMService.swift
//  RickAndMorty
//
//  Created by Tarun Sharma on 23/11/25.
//

import Foundation



/// Primary API service object o get Rick and Morty data
final class RMService{
    
    /// Shared singleton instance
    static let shared = RMService()
    
    
    /// Privatized constructor
    private init() {}
    
    
    /// Send Rick and Morty API Call
    /// - Parameters:
    ///   - request: Request instance
    ///   - type: the type of object we expect to get back
    ///   - completion: Callback with data or Error
    public func execute<T: Codable>(_ request: RMRequest,
                                    expecting type: T.Type,
                                    completion: @escaping () -> Void) {
        
    }
}
