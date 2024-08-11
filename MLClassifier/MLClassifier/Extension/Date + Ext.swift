//
//  Date + Ext.swift
//  MLClassifier
//
//  Created by 신승재 on 8/11/24.
//

import Foundation

extension Date {
    func toEnglishDateTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy HH:mm" // 영어 형식으로 설정
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: self)
    }
}


