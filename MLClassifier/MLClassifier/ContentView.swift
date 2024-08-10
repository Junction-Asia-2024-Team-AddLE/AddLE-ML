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
                        //openImagePicker()
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
    }
}

#Preview {
    ContentView()
}
