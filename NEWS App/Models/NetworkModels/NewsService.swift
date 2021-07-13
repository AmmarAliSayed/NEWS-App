//
//  NewsService.swift
//  NEWS App
//
//  Created by Macbook on 26/06/2021.
//

import Foundation
import Alamofire
class NewsService : NewsServiceProtocol{
   
   func fetchNewsData(completion :@escaping (NewsJsonData?,Error?)->()){
    let urlString = "\(URLs.baseURL)\(URLs.headline)&apikey=\(URLs.apiKey)"
       AF.request(urlString).validate().responseDecodable(of:NewsJsonData.self) { (response) in
           switch response.result{
           case .success(_):
               guard let newsData = response.value else {return}
               completion(newsData,nil)
           case .failure(let error):
               completion(nil,error)
           }
           
       }
       
   }

}

