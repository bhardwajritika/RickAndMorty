//
//  RMGetCharacterResponse.swift
//  RickAndMorty
//
//  Created by Tarun Sharma on 24/11/25.
//

import Foundation

struct RMGetAllCharacterResponse: Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
    let info: Info
    let results: [RMCharacter]
}


