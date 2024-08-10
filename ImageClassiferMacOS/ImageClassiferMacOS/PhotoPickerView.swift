//
//  PhotoPickerView.swift
//  ImageClassiferMacOS
//
//  Created by 신승재 on 8/10/24.
//

import SwiftUI

struct PhotoPickerView: NSViewRepresentable {
    @Binding var selectedImage: NSImage?

    func makeNSView(context: Context) -> some NSView {
        let button = NSButton(title: "Choose Photo", target: context.coordinator, action: #selector(Coordinator.choosePhoto))
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

        @objc func choosePhoto() {
            let dialog = NSOpenPanel()
            dialog.title = "Choose a picture"
            dialog.allowedFileTypes = ["png", "jpg", "jpeg"]
            dialog.allowsMultipleSelection = false

            if dialog.runModal() == .OK {
                if let url = dialog.url, let image = NSImage(contentsOf: url) {
                    parent.selectedImage = image
                }
            }
        }
    }
}


//#Preview {
//    PhotoPickerView(selectedImage: nil)
//}
