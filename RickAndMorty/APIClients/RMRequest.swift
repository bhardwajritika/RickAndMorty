//
//  RMRequest.swift
//  RickAndMorty
//
//  Created by Tarun Sharma on 23/11/25.
//

import Foundation


/// Object that represents a single API call

final class RMRequest {
    // Base url - https://rickandmortyapi.com/api/
    // Endpoint - character/
    // Path components - /2
    // Query parameters - ?name=rick&status=alive
    
    // https://rickandmortyapi.com/api/character/?name=rick&status=alive
    // https://rickandmortyapi.com/api/character/2
    
    
    /// API constants
    private struct Constants {
        static let baseURL = "https://rickandmortyapi.com/api"
    }
    
    /// Desired Endpoint
    private let endpoint : RMEndpoint
    
    /// PathComponents for API , if any
    private let pathComponents : Set<String>
    
    /// QueryParameters for API, if any
    private let queryParameters : [URLQueryItem]
    
    /// Constructed url for the api request n string format
    private var urlString: String {
        var string = Constants.baseURL
        string += "/"
        string += endpoint.rawValue
        
        if !pathComponents.isEmpty {
            pathComponents.forEach { string += "/\($0)" }
        }
        
        if !queryParameters.isEmpty {
            string += "?"
            // name=value&name=value&...
            let argumentString = queryParameters.compactMap({
                guard let value = $0.value else { return nil }
                return "\($0.name)=\(value)"
            }).joined(separator: "&")
            
            string += argumentString
            
        }
        return string
    }
    
    /// Computed & constructed API url
    public var url: URL? {
        return URL(string: urlString)
    }
    
    /// Desired http method
    public let httpMethod: String = "GET"
    
    // MARK: - Public
    
    /// Construct request
    /// - Parameters:
    ///   - endpoint: Target endpoint
    ///   - pathComponents: Collection of PathComponents
    ///   - queryParameters: Collection of QueryParameters
    init(endpoint: RMEndpoint,
                pathComponents: Set<String> = [],
                queryParameters: [URLQueryItem] = []
    ) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
    
}
