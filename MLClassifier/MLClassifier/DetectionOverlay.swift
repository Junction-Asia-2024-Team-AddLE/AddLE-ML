//
//  DetectionOverlay.swift
//  MLClassifier
//
//  Created by 신승재 on 8/11/24.
//

import SwiftUI
import Vision

struct DetectionOverlay: View {
    let objects: [VNRecognizedObjectObservation]
    let imageSize: CGSize
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(objects, id: \.uuid) { object in
                // Calculate the scale factor based on the image's original size and displayed size
                let scale = min(geometry.size.width / imageSize.width, geometry.size.height / imageSize.height)
                let rect = object.boundingBox

                let scaledRect = CGRect(
                    x: rect.origin.x * imageSize.width * scale,
                    y: (1 - rect.origin.y - rect.height) * imageSize.height * scale,
                    width: rect.width * imageSize.width * scale,
                    height: rect.height * imageSize.height * scale
                )

                let xOffset = (geometry.size.width - imageSize.width * scale) / 2  // Horizontal centering offset

                ZStack {
                    // Draw rectangle for detected object
                    Rectangle()
                        .stroke(Color.green, lineWidth: 4)
                        .frame(width: scaledRect.width, height: scaledRect.height)
                        .position(x: scaledRect.midX + xOffset, y: scaledRect.midY)
                }
            }
        }
    }
}

struct RecognizedObject: Identifiable {
    let id = UUID()
    var object: VNRecognizedObjectObservation
    var label: String
    var notes: String = ""
    var color: Color
}
