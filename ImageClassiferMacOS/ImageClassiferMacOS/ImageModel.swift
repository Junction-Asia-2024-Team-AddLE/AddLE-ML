//
//  ImageModel.swift
//  ImageClassiferMacOS
//
//  Created by 신승재 on 8/10/24.
//

import Foundation
import SwiftUI

struct ImageModel: Identifiable, Hashable {
    let id = UUID()
    let image: NSImage
    let confidence: Float? = nil
    let label: Int? = nil
}
