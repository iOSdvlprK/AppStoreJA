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
    let trackId: Int
    let trackName: String
    let primaryGenreName: String
    var averageUserRating: Float?
    let screenshotUrls: [String]
    let artworkUrl100: String   // app icon
    var formattedPrice: String?
    let description: String
    var releaseNotes: String?
}
