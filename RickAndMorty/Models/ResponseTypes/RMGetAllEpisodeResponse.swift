//
//  RMGetAllEpisodeResponse.swift
//  RickAndMorty
//
//  Created by Tarun Sharma on 11/12/25.
//

import Foundation

struct RMGetAllEpisodeResponse: Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    let info: Info
    let results: [RMEpisode]
}
