//
//  Constants.swift
//  HarryPotterLibrary
//
//  Created by 백래훈 on 3/26/25.
//

import UIKit

enum Constants {
    enum Image: String {
        case harrypotter1 = "harrypotter1"
        case harrypotter2 = "harrypotter2"
        case harrypotter3 = "harrypotter3"
        case harrypotter4 = "harrypotter4"
        case harrypotter5 = "harrypotter5"
        case harrypotter6 = "harrypotter6"
    }
    
    enum Title {
        static let author = "Author"
        static let released = "Released"
        static let page = "Page"
        static let dedication = "Dedication"
        static let summary = "Summary"
        static let chapters = "Chapters"
    }
    
    enum Summary {
        static let maxLength = 450
    }
    
    enum ButtonTitle {
        static let more = "더 보기"
        static let less = "접기"
    }
    
    enum Alert {
        static let confirm = "확인"
        static let cancel = "취소"
        static let retryMessage = "다시 시도해 주세요."
    }
}
