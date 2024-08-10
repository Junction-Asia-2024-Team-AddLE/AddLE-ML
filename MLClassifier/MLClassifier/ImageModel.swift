//
//  ImageModel.swift
//  MLClassifier
//
//  Created by 신승재 on 8/10/24.
//

import Foundation
import SwiftUI

struct ImageModel: Identifiable, Hashable {
    var id = UUID()
    let image: UIImage
    let croppedImage: UIImage?
    let confidence: Float?
    let label: Int?
    var boundingBox: CGRect?
    
    init(image: UIImage, croppedImage: UIImage? = nil, confidence: Float? = nil, label: Int? = nil, boundingBox: CGRect? = nil) {
        self.id = UUID()
        self.image = image
        self.croppedImage = croppedImage
        self.confidence = confidence
        self.label = label
        self.boundingBox = boundingBox
    }
    
    static func == (lhs: ImageModel, rhs: ImageModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        // You can also combine other properties if needed and they are hashable
    }
}
