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
    @State private var isLoading = false
    
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
                        Text("+ Add Image")
                            .font(Font.system(size: 20))
                    })
                    .padding(10)
                    .buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                }
            }.frame(width: 450)
            
            
            Divider()
            
            if let selectedItemIndex = imageItems.firstIndex(where: { $0.id == selectedItem?.id }) {
                VStack(spacing: 0) {
                    Spacer().frame(height: 50)
                    
                    Image(uiImage: imageItems[selectedItemIndex].image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: 500)
                    
                    Spacer().frame(height: 50)
                    
                    VStack(spacing: 10) {
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Time").bold()
                                Text(imageItems[selectedItemIndex].date.toKoreanDateTimeString())
                                    .font(.subheadline)
                                    .foregroundStyle(.gray)
                            }
                            Spacer()
                        }
                        .font(Font.system(size: 20))
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 0.8)
                        )
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Result").bold()
                                switch imageItems[selectedItemIndex].croppedImages.count {
                                case 0:
                                    Text("Stealth Vehicle")
                                        .font(.subheadline)
                                        .foregroundStyle(.gray)
                                case 1:
                                    Text("One Side Malfunction")
                                        .font(.subheadline)
                                        .foregroundStyle(.gray)
                                case 2:
                                    Text("Normal")
                                        .font(.subheadline)
                                        .foregroundStyle(.gray)
                                default:
                                    Text("Error")
                                        .font(.subheadline)
                                        .foregroundStyle(.gray)
                                }
                            }
                            Spacer()
                        }
                        .font(Font.system(size: 20))
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 0.8)
                        )
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("latitude, longitude").bold()
                                Text("\(imageItems[selectedItemIndex].latitude), \(imageItems[selectedItemIndex].longitude)")
                                    .font(.subheadline)
                                    .foregroundStyle(.gray)
                            }
                            
                            Spacer()
                        }
                        .font(Font.system(size: 20))
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 0.8)
                        )
                        
                    }.padding(.horizontal, 20)
                    
                    
                    Spacer()
                    
                    Divider()
                    
                    HStack {
                        
                        Spacer()
                        
                        if !imageItems[selectedItemIndex].isUploaded {
                            Button(action: {
                                Task {
                                    isLoading = true
                                    await FirebaseService.shared.uploadImage(imageModel: imageItems[selectedItemIndex])
                                    imageItems[selectedItemIndex].isUploaded = true
                                    isLoading = false
                                }
                            }, label: {
                                if !isLoading {
                                    Text("Upload Image")
                                        .font(Font.system(size: 20))
                                        .foregroundStyle(.white)
                                        .padding(10)
                                } else {
                                    ProgressView()
                                        .frame(width: 40, height: 40)
                                }
                                
                                
                            })
                            
                        } else {
                            Text("Upload Complete")
                                .font(Font.system(size: 20))
                                .foregroundStyle(.white)
                                .padding(10)
                        }
                        
                    }
                    
                    

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
