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
