//
//  RMGetLocationsResponse.swift
//  RickAndMorty
//
//  Created by Tarun Sharma on 19/12/25.
//

import Foundation

struct RMGetLocationsResponse: Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    let info: Info
    let results: [RMLocation]
}

