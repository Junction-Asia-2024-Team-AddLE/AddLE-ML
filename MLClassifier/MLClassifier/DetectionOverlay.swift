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
    let carBoundingBox: CGRect? // 차량 바운딩 박스
    let imageSize: CGSize
    
    var body: some View {
        GeometryReader { geometry in
            let scale = min(geometry.size.width / imageSize.width, geometry.size.height / imageSize.height)

            // 차량 바운딩 박스 그리기
            if let carBox = carBoundingBox {
                let carRect = calculateScaledRect(from: carBox, imageSize: imageSize, scale: scale)
                Rectangle()
                    .stroke(Color.red, lineWidth: 6) // 차량은 파란색으로 표시
                    .frame(width: carRect.width, height: carRect.height)
                    .position(x: carRect.midX + (geometry.size.width - imageSize.width * scale) / 2, y: carRect.midY)
            }

            // 후미등 바운딩 박스 그리기
            ForEach(objects, id: \.uuid) { object in
                let rect = calculateScaledRect(from: object.boundingBox, imageSize: imageSize, scale: scale)

                Rectangle()
                    .stroke(Color.green, lineWidth: 6) // 후미등은 빨간색으로 표시
                    .frame(width: rect.width, height: rect.height)
                    .position(x: rect.midX + (geometry.size.width - imageSize.width * scale) / 2, y: rect.midY)
            }
        }
    }

    private func calculateScaledRect(from boundingBox: CGRect, imageSize: CGSize, scale: CGFloat) -> CGRect {
        return CGRect(
            x: boundingBox.origin.x * imageSize.width * scale,
            y: (1 - boundingBox.origin.y - boundingBox.height) * imageSize.height * scale,
            width: boundingBox.width * imageSize.width * scale,
            height: boundingBox.height * imageSize.height * scale
        )
    }
}
struct RecognizedObject: Identifiable {
    let id = UUID()
    var object: VNRecognizedObjectObservation
    var label: String
    var notes: String = ""
    var color: Color
}
