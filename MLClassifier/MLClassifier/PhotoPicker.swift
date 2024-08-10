//
//  PhotoPicker.swift
//  MLClassifier
//
//  Created by 신승재 on 8/10/24.
//

import SwiftUI
import PhotosUI

// PHPicker를 SwiftUI에서 사용할 수 있도록 UIViewControllerRepresentable로 래핑
import SwiftUI
import PhotosUI

struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var selectedImageModels: [ImageModel]
    private let objectDetector = ObjectDetector()

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.selectionLimit = 0
        configuration.filter = .images

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self, objectDetector: objectDetector)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoPicker
        let objectDetector: ObjectDetector

        init(_ parent: PhotoPicker, objectDetector: ObjectDetector) {
            self.parent = parent
            self.objectDetector = objectDetector
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true, completion: nil)

            for result in results {
                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
                        if let image = object as? UIImage {
                            self?.processImage(image)
                        }
                    }
                }
            }
        }

        func processImage(_ image: UIImage) {
            objectDetector.detectTailLampObjects(in: image) { observations in
                guard let observations = observations else { return }

                for observation in observations {
                    let imageSize = CGSize(width: image.size.width, height: image.size.height)
                    let boundingBox = observation.boundingBox
                    let cropRect = self.calculateCropRect(from: boundingBox, imageSize: imageSize)

                    if let croppedImage = self.objectDetector.cropImage(image, toRect: cropRect) {
                        self.objectDetector.classifyObject(in: croppedImage) { classification in
                            DispatchQueue.main.async {
                                let confidence = classification?.confidence ?? 0.0
                                let label = Int(classification!.identifier)
                                let newImageModel = ImageModel(
                                    image: image,
                                    confidence: confidence,
                                    label: label,
                                    boundingBox: boundingBox
                                )
                                self.parent.selectedImageModels.append(newImageModel)
                            }
                        }
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
}
