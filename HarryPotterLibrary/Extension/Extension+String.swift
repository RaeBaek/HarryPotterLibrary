//
//  Extension+String.swift
//  HarryPotterLibrary
//
//  Created by 백래훈 on 3/31/25.
//

import Foundation

extension String {
    var formattedDate: String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMM dd, yyyy"
        outputFormatter.locale = Locale(identifier: "en_US")
        
        if let date = inputFormatter.date(from: self) {
            return outputFormatter.string(from: date)
        } else {
            return self // 실패 시 원본 반환
        }
    }
}
