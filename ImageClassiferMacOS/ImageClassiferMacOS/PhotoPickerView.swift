//
//  PhotoPickerView.swift
//  ImageClassiferMacOS
//
//  Created by 신승재 on 8/10/24.
//

import SwiftUI

struct PhotoPickerView: NSViewRepresentable {
    @Binding var selectedImages: [ImageModel]
    func makeNSView(context: Context) -> some NSView {
        let button = NSButton(title: "Choose Photos", target: context.coordinator, action: #selector(Coordinator.choosePhotos))
        return button
    }

    func updateNSView(_ nsView: NSViewType, context: Context) {
        // No updates needed for static button
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        var parent: PhotoPickerView

        init(_ parent: PhotoPickerView) {
            self.parent = parent
        }

        @objc func choosePhotos() {
            let dialog = NSOpenPanel()
            dialog.title = "Choose pictures"
            dialog.allowedFileTypes = ["png", "jpg", "jpeg"]
            dialog.allowsMultipleSelection = true

            if dialog.runModal() == .OK {
                for url in dialog.urls {
                    if let image = NSImage(contentsOf: url) {
                        let imageTitle = url.lastPathComponent
                        let newItem = ImageModel(image: image)
                        parent.selectedImages.append(newItem)
                    }
                }
            }
        }
    }
}



//#Preview {
//    PhotoPickerView(selectedImage: nil)
//}
