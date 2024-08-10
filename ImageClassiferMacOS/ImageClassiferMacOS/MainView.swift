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
    @State private var imageItems: [ImageModel] = []
    @State private var isShowingPhotoPicker = false
    @State private var selectedItem: ImageModel? = nil

    var body: some View {
        HStack {
            VStack {
                Button(action: {
                    isShowingPhotoPicker = true
                }) {
                    Text("Add Images")
                        .font(.title)
                        .padding()
                }
                List(selection: $selectedItem) {
                    ForEach(imageItems) { item in
                        Text("\(item.id)")
                            .tag(item)
                    }
                }
                .frame(minWidth: 200)
            }
            Divider()
            if let selectedItem = selectedItem {
                Image(nsImage: selectedItem.image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Text("No Image Selected")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .sheet(isPresented: $isShowingPhotoPicker) {
            PhotoPickerView(selectedImages: $imageItems)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
#Preview {
    MainView()
}
