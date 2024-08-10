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
    var confidence: Float
    var label: Int
    var processStatus: Int
    
    enum CodingKeys: String, CodingKey {
        case date, confidence, label
        case imageUrl = "image"
        case processStatus = "status"
    }
}

struct FStore {
    static let collection = "Detection"
    static let date = "date"
    static let image = "image"
    static let confidence = "confidence"
    static let label = "label"
    static let process = "status"
}
