//
//  ContentView.swift
//  ImageClassiferMacOS
//
//  Created by 신승재 on 8/10/24.
//

import SwiftUI
import Vision
import PhotosUI

struct MainView: View {
    @State private var image: NSImage? = nil
    @State privagt var imageItems: 
    @State private var recognizedObjects: [VNRecognizedObjectObservation] = []
    @State private var classifications: [VNClassificationObservation] = []

    private let objectDetector = ObjectDetector()

    var body: some View {
        VStack {
            
        }
    }
}

extension MainView {
    private func detectObjects(in image: NSImage) {
        objectDetector.detectTailLampObjects(in: image) { results in
            DispatchQueue.main.async {
                self.recognizedObjects = results ?? []

                guard let firstObject = self.recognizedObjects.first else {
                    print("No recognized objects found.")
                    return
                }

                let imageSize = CGSize(width: image.size.width, height: image.size.height)

                let boundingBox = firstObject.boundingBox
                let cropRect = calculateCropRect(from: boundingBox, imageSize: imageSize)
                
                if let croppedImage = self.objectDetector.cropImage(image, toRect: cropRect) {
                    self.image = croppedImage
//                    self.objectDetector.classifyObject(in: xcroppedImage) { classification in
//                        if let classification = classification {
//                            DispatchQueue.main.async {
//                                self.classifications.append(classification)
//                                print(classification)
//                            }
//                        }
//                    }
                } else {
                    print("Failed to crop image.")
                }
            }
        }
    }
    
    private func calculateCropRect(from boundingBox: CGRect, imageSize: CGSize) -> CGRect {
        return CGRect(
            x: boundingBox.origin.x * imageSize.width,
            y: (1 - boundingBox.origin.y - boundingBox.height) * imageSize.height,
            width: boundingBox.width * imageSize.width,
            height: boundingBox.height * imageSize.height
        )
    }
}


#Preview {
    MainView()
}
