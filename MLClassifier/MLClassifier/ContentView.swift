//
//  ContentView.swift
//  MLClassifier
//
//  Created by 신승재 on 8/10/24.
//

import SwiftUI
import Vision

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
                        HStack {
                            Image(systemName: "plus")
                                .frame(width:45, height: 45)
                            
                            Text("Add Image")
                                .font(Font.system(size: 20))
                        }
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
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity, maxHeight: 500)
                        .overlay(
                            DetectionOverlay(
                                objects: imageItems[selectedItemIndex].tailLampsboundingBoxs.map { box in
                                    let observation = VNRecognizedObjectObservation(boundingBox: box!)
                                    return observation
                                },
                                carBoundingBox: imageItems[selectedItemIndex].carBoundingBox,
                                imageSize: imageItems[selectedItemIndex].image.size
                            )
                        )
                    
                    Spacer().frame(height: 50)
                    
                    
                    VStack(spacing: 20) {
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Result").bold()
                                switch imageItems[selectedItemIndex].croppedImages.count {
                                case 0:
                                    Text("Stealth Vehicle")
                                        .foregroundStyle(.red)
                                case 1:
                                    Text("One Side Malfunction")
                                        .foregroundStyle(.yellow)
                                case 2:
                                    Text("Normal")
                                        .foregroundStyle(.green)
                                default:
                                    Text("Normal")
                                        .foregroundStyle(.green)
                                }
                            }
                            Spacer()
                        }
                        .font(Font.system(size: 30))
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 0.8)
                        )
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Time").bold()
                                Text(imageItems[selectedItemIndex].date.toKoreanDateTimeString())
                                    .foregroundStyle(.gray)
                            }
                            Spacer()
                        }
                        .font(Font.system(size: 30))
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 0.8)
                        )
                        
                       
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("latitude, longitude").bold()
                                Text("\(imageItems[selectedItemIndex].latitude), \(imageItems[selectedItemIndex].longitude)")
                                    .foregroundStyle(.gray)
                            }
                            
                            Spacer()
                        }
                        .font(Font.system(size: 30))
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 0.8)
                        )
                        
                    }.padding(.horizontal, 20)
                    
                    
                    Spacer()
                    
                    
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
                                ZStack {
                                    RoundedRectangle(cornerRadius: 25)
                                        .frame(width: 150, height: 40)
                                    
                                    if !isLoading {
                                        Text("Upload Image")
                                            .font(Font.system(size: 20))
                                            .foregroundStyle(.white)
                                            .padding(10)
                                    } else {
                                        ProgressView()
                                            .frame(width: 40, height: 40)
                                    }
                                    
                                }
                            })
                            .padding()
                            
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
