//
//  NewsModel.swift
//  Demo-Blog
//
//  Created by Sam on 28/06/23.
//

import Foundation

// MARK: - NewsModel
struct NewsModel: Codable {
    let status: String?
    let totalResults: Int?
    let articles: [Article]?
}

// MARK: - Article
struct Article: Codable {
    let source: Source?
    let author, title, description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt, content: String?
}

// MARK: - Source
struct Source: Codable {
    let id: ID?
    let name: Name?
}

enum ID: String, Codable {
    case medicalNewsToday = "medical-news-today"
}

enum Name: String, Codable {
    case medicalNewsToday = "Medical News Today"
}
