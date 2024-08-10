//
//  ContentView.swift
//  MLClassifier
//
//  Created by 신승재 on 8/10/24.
//

import SwiftUI

struct ContentView: View {
    @State private var imageItems: [ImageModel] = []
    @State private var selectedItem: ImageModel? = nil
    @State private var isPickerPresented = false
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(spacing: 0) {
                List(selection: $selectedItem) {
                    ForEach(imageItems) { item in
                        Text("\(item.id)")
                            .tag(item)
                    }
                }
                
                
                Divider()
                
                HStack {
                    Button(action: {
                        isPickerPresented = true
                    }, label: {
                        Text("+ 이미지 추가하기")
                            .font(.headline)
                    })
                    .padding(10)
                    .buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                }
            }.frame(width: 350)
            
            
            Divider()
            
            if let selectedItem = selectedItem {
                VStack {
                    Spacer().frame(height: 100)
                    Image(uiImage: selectedItem.image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: 500)
//                        .onAppear() {
//                            print(selectedItem.label)
//                            print(selectedItem.confidence)
//                        }
                    Image(uiImage: selectedItem.croppedImage!)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 300)
                    
                    Text("\(selectedItem.label)")
                    Text("\(selectedItem.confidence)")
                    Text("\(selectedItem.boundingBox)")
                    Spacer()
                }
            } else {
                Text("No Image Selected")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $isPickerPresented) {
            PhotoPicker(selectedImageModels: $imageItems)
        }
    }
}

#Preview {
    ContentView()
}
