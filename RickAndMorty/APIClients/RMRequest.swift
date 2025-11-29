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
    private let pathComponents : [String]
    
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
    public init(endpoint: RMEndpoint,
                pathComponents: [String] = [],
                queryParameters: [URLQueryItem] = []
    ) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
    
    convenience init?(url: URL) {
        let string = url.absoluteString
        if !string.contains(Constants.baseURL) {
            return nil
        }
        let trimmed = string.replacingOccurrences(of: Constants.baseURL + "/", with: "")
        if trimmed.contains("/") {
            let components = trimmed.components(separatedBy: "/")
            if !components.isEmpty {
                let endpointString = components[0]
                if let rmEndpoint = RMEndpoint(rawValue: endpointString) {
                    self.init(endpoint: rmEndpoint)
                    return
                }
            }
        } else if trimmed.contains("?") {
            let components = trimmed.components(separatedBy: "?")
            if !components.isEmpty , components.count >= 2 {
                let endpointString = components[0]
                let queryItemsString = components[1]
                // value=name&value=name
                let queryItems: [URLQueryItem] = queryItemsString
                    .components(separatedBy: "&")
                    .compactMap { item -> URLQueryItem? in
                        guard item.contains("=") else { return nil }
                        let parts = item.components(separatedBy: "=")
                        guard parts.count == 2 else { return nil }

                        return URLQueryItem(
                            name: parts[0],
                            value: parts[1]
                        )
                    }
                if let rmEndpoint = RMEndpoint(rawValue: endpointString) {
                    self.init(endpoint: rmEndpoint, queryParameters: queryItems)
                    return
                }
            }
        }
        return nil
    }
    
}

extension RMRequest {
    static let listCharactersRequests = RMRequest(endpoint: .character)
}
