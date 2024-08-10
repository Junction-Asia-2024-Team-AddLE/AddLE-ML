//
//  PhotoPicker.swift
//  MLClassifier
//
//  Created by 신승재 on 8/10/24.
//

import SwiftUI
import PhotosUI

// PHPicker를 SwiftUI에서 사용할 수 있도록 UIViewControllerRepresentable로 래핑
struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var selectedImageModels: [ImageModel]
    
    private let objectDetector = ObjectDetector()

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.selectionLimit = 0 // 0은 무제한 선택을 의미
        configuration.filter = .images

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // Coordinator 클래스는 델리게이트 역할을 합니다.
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoPicker

        init(_ parent: PhotoPicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true, completion: nil)

            parent.selectedImageModels = [] // 선택된 이미지 모델 배열 초기화

            for result in results {
                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
                        if let image = object as? UIImage {
                            DispatchQueue.main.async {
                                // ImageModel 인스턴스 생성 및 추가
                                let imageModel = ImageModel(image: image)
                                self?.parent.selectedImageModels.append(imageModel)
                            }
                        }
                    }
                }
            }
        }
    }
}
