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
    ///   - completion: Callback with data or Error
    public func execute(_ request: RMRequest, completion: @escaping () -> Void) {
        
    }
}
