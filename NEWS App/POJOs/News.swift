//
//  News.swift
//  NEWS App
//
//  Created by Macbook on 26/06/2021.
//

import Foundation
struct NewsJsonData: Codable {
    let status: String
    let totalResults: Int
    let articles: [News]
}

struct News: Codable {
    let author: String?
    let title: String?
    let description: String?
    let urlToImage: String?
    let url: String?
}
