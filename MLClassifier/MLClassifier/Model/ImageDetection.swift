//
//  ImageDetection.swift
//  MLClassifier
//
//  Created by 신승재 on 8/10/24.
//

import Foundation

struct ImageDetection: Codable {
    var date: Date
    var imageUrl: String
    var label: Int
    var processStatus: Int
    var latitude: Float
    var longitude: Float
    var address: String
    var roadName: String
    
    enum CodingKeys: String, CodingKey {
        case date, label, latitude, longitude, address, roadName
        case imageUrl = "image"
        case processStatus = "status"
    }
}

struct FStore {
    static let collection = "Detection"
    static let date = "date"
    static let image = "image"
    static let label = "label"
    static let process = "status"
    static let latitude = "latitude"
    static let longitude = "longitude"
    static let address = "address"
    static let roadName = "roadName"
}
