//
//  PhotoPicker.swift
//  MLClassifier
//
//  Created by 신승재 on 8/10/24.
//

import SwiftUI
import PhotosUI

struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var selectedImageModels: [ImageModel]
    @State private var croppedImages: [UIImage] = []
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

                var croppedImages: [UIImage?] = []
                var boundingBoxes: [CGRect?] = []

                // 모든 감지된 객체에 대해 처리
                for observation in observations {
                    let imageSize = CGSize(width: image.size.width, height: image.size.height)
                    let cropRect = self.calculateCropRect(from: observation.boundingBox, imageSize: imageSize)

                    if let croppedImage = self.objectDetector.cropImage(image, toRect: cropRect) {
                        croppedImages.append(croppedImage)
                        boundingBoxes.append(observation.boundingBox)
                    }
                }

                // 감지된 객체가 없거나, 첫 번째 객체의 분류 정보를 사용하는 경우에 대한 처리
                if !croppedImages.isEmpty {
                    let firstCroppedImage = croppedImages[0] ?? image
                    self.objectDetector.classifyObject(in: firstCroppedImage) { classification in
                        DispatchQueue.main.async {
                            let label = Int(classification?.identifier ?? "") ?? 0

                            // ImageModel 생성
                            let newImageModel = ImageModel(
                                image: image,
                                croppedImages: croppedImages,
                                label: label,
                                tailLampsboundingBoxs: boundingBoxes,
                                isUploaded: false
                            )
                            self.parent.selectedImageModels.append(newImageModel)
                        }
                    }
                } else {
                    // 객체가 감지되지 않은 경우에 대한 기본 ImageModel
                    let newImageModel = ImageModel(
                        image: image,
                        croppedImages: [],
                        label: nil,
                        tailLampsboundingBoxs: [],
                        isUploaded: false
                    )
                    self.parent.selectedImageModels.append(newImageModel)
                }
            }
        }


        private func calculateCropRect(from boundingBox: CGRect, imageSize: CGSize) -> CGRect {
            return CGRect(
                x: boundingBox.origin.x * imageSize.width,
                y: (1 - boundingBox.origin.y) * imageSize.height - boundingBox.height * imageSize.height,
                width: boundingBox.width * imageSize.width,
                height: boundingBox.height * imageSize.height
            )
        }
    }
}
