//
//  File.swift
//  ACRCloudExample
//
//  Created by Tugce on 7/28/19.
//  Copyright © 2019 tugce. All rights reserved.
//

import Foundation

// MARK: - SongsData
class SongsData: Codable {
    var metadata: Metadata?
    var status: Status?
    var resultType: Int?
    var costTime: Double?
    
    enum CodingKeys: String, CodingKey {
        case metadata, status
        case resultType = "result_type"
        case costTime = "cost_time"
    }
}

// MARK: - Metadata
class Metadata: Codable {
    var timestampUTC: String?
    var music: [Music]?
    
    enum CodingKeys: String, CodingKey {
        case timestampUTC = "timestamp_utc"
        case music
    }
}

// MARK: - Music
class Music: Codable {
    var label: String?
    var externalMetadata: ExternalMetadata?
    var album: ArtistClass?
    var artists: [ArtistClass]?
    var resultFrom: Int?
    var acrid, title: String?
    var durationMS: Int?
    var releaseDate: String?
    var genres: [ArtistClass]?
    var score: Int?
    var playOffsetMS: Int?
    var externalIDS: ExternalIDS?
    
    enum CodingKeys: String, CodingKey {
        case label
        case externalMetadata = "external_metadata"
        case album, artists
        case resultFrom = "result_from"
        case acrid, title
        case durationMS = "duration_ms"
        case releaseDate = "release_date"
        case genres, score
        case playOffsetMS = "play_offset_ms"
        case externalIDS = "external_ids"
    }
}

// MARK: - ArtistClass
class ArtistClass: Codable {
    var name: String?
}

// MARK: - ExternalIDS
class ExternalIDS: Codable {
    var upc, isrc: String?
}

// MARK: - ExternalMetadata
class ExternalMetadata: Codable {
    var spotify: Spotify?
    //var deezer: Deezer?
    
}
/*
// MARK: - Deezer
class Deezer: Codable {
    var track: Track?
    var artists: [Artist]?
    var album: DeezerAlbum?
    
}

// MARK: - DeezerAlbum
class DeezerAlbum: Codable {
    var id: String?
}

// MARK: - Artist
class Artist: Codable {
    var id: String?
    var name: String?
    
}
*/
// MARK: - Track
class Track: Codable {
    var name, id: String?
    
}

class TrackArtist: Codable {
    var id: String?
    var name: String?
}

class TrackAlbum: Codable {
    var id: String?
    
}

// MARK: - Spotify
class Spotify: Codable {
    var track: Track?
    var artists: [TrackArtist]?
    var album: TrackAlbum?
    
}

// MARK: - Status
class Status: Codable {
    var msg, version: String?
    var code: Int = 0
    
}
