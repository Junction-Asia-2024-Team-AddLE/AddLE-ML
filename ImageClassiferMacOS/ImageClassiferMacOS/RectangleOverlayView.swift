//
//  RectangleOverlayView.swift
//  ImageClassiferMacOS
//
//  Created by 신승재 on 8/10/24.
//

import SwiftUI

struct RectangleOverlayView: View {
    @Binding var boundingBox: CGRect?

    var body: some View {
        GeometryReader { geometry in
            if let boundingBox = boundingBox {
                Rectangle()
                    .path(in: CGRect(x: boundingBox.origin.x * geometry.size.width,
                                     y: (1 - boundingBox.origin.y - boundingBox.height) * geometry.size.height,
                                     width: boundingBox.width * geometry.size.width,
                                     height: boundingBox.height * geometry.size.height))
                    .stroke(Color.red, lineWidth: 3)
            }
        }
    }
}

