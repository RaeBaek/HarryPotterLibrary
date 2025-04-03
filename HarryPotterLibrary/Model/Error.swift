//
//  Error.swift
//  HarryPortterLibrary
//
//  Created by 백래훈 on 3/24/25.
//

import Foundation

enum DataError: String, Error {
    case fileNotFound = "파일을 찾을 수 없습니다."
    case parsingFailed = "JSON 파싱에 실패하였습니다."
}

enum ButtonError: String {
    case findNotButton = "더 보기 버튼을 찾을 수 없습니다."
}

enum IndexError: String {
    case outOfRange = "잘못된 인덱스입니다."
}

enum BookError: String {
    case noInfoSummary = "책에 대한 요약 정보를 불러올 수 없습니다."
}
