//
//  ImageModel.swift
//  MLClassifier
//
//  Created by 신승재 on 8/10/24.
//

import Foundation
import SwiftUI

struct ImageModel: Identifiable, Hashable {
    var id = UUID()
    let date: Date
    let image: UIImage
    let croppedImages: [UIImage?]
    let label: Int?
    var tailLampsboundingBoxs: [CGRect?]
    var isUploaded: Bool
    var latitude: Float
    var longitude: Float
    
    init(image: UIImage, croppedImages: [UIImage?] = [], label: Int? = nil, tailLampsboundingBoxs: [CGRect?] = [], isUploaded: Bool = false) {
        self.id = UUID()
        self.image = image
        self.croppedImages = croppedImages
        self.label = label
        self.tailLampsboundingBoxs = tailLampsboundingBoxs
        self.isUploaded = isUploaded
        self.date = ImageModel.randomPastDate() // 과거의 랜덤 날짜로 설정

        // 랜덤으로 선택된 경도와 위도 쌍으로 설정
        let randomCoordinate = ImageModel.randomCoordinate()
        self.latitude = randomCoordinate.latitude
        self.longitude = randomCoordinate.longitude
    }
    
    static func == (lhs: ImageModel, rhs: ImageModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    /// 과거의 임의 날짜 생성
    private static func randomPastDate() -> Date {
        let calendar = Calendar.current
        let now = Date()

        // 과거 1년 전부터 현재까지의 범위
        if let oneYearAgo = calendar.date(byAdding: .year, value: -1, to: now) {
            // 현재와 1년 전 사이의 임의의 시간 생성
            let randomTimeInterval = TimeInterval.random(in: oneYearAgo.timeIntervalSince1970...now.timeIntervalSince1970)
            return Date(timeIntervalSince1970: randomTimeInterval)
        }

        return now // 만약 날짜 계산에 실패하면 현재 날짜 반환
    }

    /// 주어진 좌표 배열
    private static let coordinates: [(latitude: Float, longitude: Float)] = [
        (latitude: 36.0228754, longitude: 129.3509383),
        (latitude: 36.03925931, longitude: 129.3540977),
        (latitude: 36.0312174, longitude: 129.3460629),
        (latitude: 36.02077355, longitude: 129.3589672),
        (latitude: 36.02531912, longitude: 129.344873),
        (latitude: 36.01886784, longitude: 129.3551275),
        (latitude: 36.03231956, longitude: 129.3434041),
        (latitude: 35.99212161, longitude: 129.3448126),
        (latitude: 36.09790064, longitude: 129.3711609)
    ]
    
    /// 랜덤 좌표 선택
    private static func randomCoordinate() -> (latitude: Float, longitude: Float) {
        return coordinates.randomElement() ?? (latitude: 0.0, longitude: 0.0)
    }
}
