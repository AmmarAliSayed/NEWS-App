//
//  NewsServiceProtocol.swift
//  NEWS App
//
//  Created by Macbook on 07/07/2021.
//

import Foundation

protocol NewsServiceProtocol {
    func fetchNewsData(completion :@escaping (NewsJsonData?,Error?)->())
}
