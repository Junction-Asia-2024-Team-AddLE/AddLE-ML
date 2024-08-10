//
//  Date + Ext.swift
//  MLClassifier
//
//  Created by 신승재 on 8/11/24.
//

import Foundation

extension Date {
    func toKoreanDateTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월 d일 HH시 mm분"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: self)
    }
}

