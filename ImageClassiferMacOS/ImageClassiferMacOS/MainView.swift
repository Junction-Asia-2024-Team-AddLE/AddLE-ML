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
    @State private var isShowingPhotoPicker = false
    @State private var recognizedObjects: [VNRecognizedObjectObservation] = []
    @State private var isShowingAlert = false
    @State private var imageClassification = ""
    @State private var classifications: [VNClassificationObservation] = []

    private let objectDetector = ObjectDetector()

    var body: some View {
        VStack {
            if let image = image {
                Image(nsImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 500)
            } else {
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 300, height: 300)
                    .overlay(
                        Text("No Image Selected")
                            .foregroundColor(.white)
                    )
            }

            Button(action: {
                isShowingPhotoPicker = true
            }) {
                Text("Select Image")
                    .font(.title)
            }
            .padding()

            Button(action: {
                if let image = image {
                    detectObjects(in: image)
                }
            }, label: {
                Text("Detect Objects")
            })
        }
        .alert("Important Message", isPresented: $isShowingAlert) {
            Button("OK", role: .cancel) {
                // Define the action when OK is pressed.
            }
        } message: {
            Text("Information")
        }
        .sheet(isPresented: $isShowingPhotoPicker) {
            PhotoPickerView(selectedImage: $image)
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

#Preview {
    MainView()
}
