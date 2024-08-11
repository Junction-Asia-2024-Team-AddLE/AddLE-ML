//
//  FirebaseService.swift
//  MLClassifier
//
//  Created by 신승재 on 8/10/24.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore
import CoreLocation

final class FirebaseService {
    static let shared = FirebaseService()
    private init() {}
    
    private let store = Firestore.firestore()
    private let storage = Storage.storage(url: Bundle.main.STORAGE_URL)
}

// MARK: - FireStore
extension FirebaseService {
    func createStore(_ data: ImageDetection) async {
        do {
            let ref = try await store
                .collection(FStore.collection)
                .addDocument(data: [
                    FStore.date : Date(),
                    FStore.image : data.imageUrl,
                    FStore.process : data.processStatus,
                    FStore.latitude : data.latitude,
                    FStore.longitude : data.longitude,
                    FStore.address : data.address,
                    FStore.roadName : data.roadName,
                ])
            print("Document added with ID: \(ref.documentID)")
        } catch {
            print("Error adding document: \(error)")
        }
    }
    
    func fetchStore() async {
        do {
            let snapshot = try await store.collection(FStore.collection).getDocuments()
            for document in snapshot.documents {
                //                print("\(document.documentID) => \(document.data())")
                let data = try? document.data(as: ImageDetection.self)
                print(data)
            }
        } catch {
            print("Error getting documents: \(error)")
        }
    }
}

// MARK: - Storage
extension FirebaseService {
    func uploadImage(imageModel: ImageModel) async {
        let storageRef = storage.reference()
        let imagesRef = storageRef.child("images/\(imageModel.id).jpg")
        
        let image = imageModel.image
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        
        let result = try? await imagesRef.putDataAsync(imageData)
        print("Result: \(result)")
        
        let url = try? await imagesRef.downloadURL()
        
        let addresses = await getAddressFromCoordinates(
            latitude: CLLocationDegrees(imageModel.latitude),
            longitude: CLLocationDegrees(imageModel.longitude)
        )
        
        let data = ImageDetection(
            date: .now,
            imageUrl: url?.absoluteString ?? "",
            label: imageModel.croppedImages.count,
            processStatus: 0,
            latitude: imageModel.latitude,
            longitude: imageModel.longitude,
            address: addresses.1,
            roadName: addresses.0
        )
        
        await createStore(data)
    }
    
    func getAddressFromCoordinates(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async -> (String, String) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()
        
        let placemarks = try? await geocoder.reverseGeocodeLocation(location, preferredLocale: Locale(identifier: "en_US"))
        
        if let placemark = placemarks?.first {
            // 도로명 주소를 구성하기 위한 필드들
            let roadName = placemark.thoroughfare ?? ""    // 도로명
            let subLocality = placemark.subLocality ?? ""  // 동/읍/면
            let locality = placemark.locality ?? ""        // 시/군/구
            let administrativeArea = placemark.administrativeArea ?? "" // 도/광역시
            let postalCode = placemark.postalCode ?? ""    // 우편번호
            
            let rn = "\(postalCode), \(roadName) \(subLocality)"
            let address = "\(locality), \(administrativeArea)"
            
            return (rn, address)
        }
        return ("None", "None")
    }
}
