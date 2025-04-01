//
//  Response.swift
//  HarryPortterLibrary
//
//  Created by 백래훈 on 3/24/25.
//

import Foundation

// MARK: - BookResponse
struct BookResponse: Decodable {
    let data: [Attribute]
}

// MARK: - attribute
struct Attribute: Decodable {
    let attributes: Book
}

// MARK: - Attributes
struct Book: Decodable {
    let title, author: String
    let pages: Int
    let releaseDate, dedication, summary: String
    let wiki: String
    let chapters: [Chapter]

    enum CodingKeys: String, CodingKey {
        case title, author, pages
        case releaseDate = "release_date"
        case dedication, summary, wiki, chapters
    }
}

// MARK: - Chapter
struct Chapter: Codable {
    let title: String
}
