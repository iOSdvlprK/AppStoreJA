//
//  SearchResult.swift
//  AppStoreJA
//
//  Created by joe on 2023/04/25.
//

import Foundation

struct SearchResult: Decodable {
    let resultCount: Int
    let results: [Result]
}

struct Result: Decodable {
    let trackName: String
    let primaryGenreName: String
}