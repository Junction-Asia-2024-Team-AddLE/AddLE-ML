//
//  ImageModel.swift
//  ImageClassiferMacOS
//
//  Created by 신승재 on 8/10/24.
//

import Foundation
import SwiftUI

struct ImageModel {
    let id = UUID()
    let image: NSImage
    let confidence: Float?
    let label: Int?
}
