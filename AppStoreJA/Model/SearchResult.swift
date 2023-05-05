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
    var averageUserRating: Float?
    let screenshotUrls: [String]
    let artworkUrl100: String   // app icon
    let formattedPrice: String
    let description: String
    let releaseNotes: String
}
