//
//  MockNewsService.swift
//  NEWS AppTests
//
//  Created by Macbook on 06/07/2021.
//NewsServiceTests

import Foundation
@testable import NEWS_App
//check the Api response in succuess and fail
class MockNewsService {
    var shouldReturnError : Bool
    
    init(shouldReturnError : Bool) {
        self.shouldReturnError = shouldReturnError
    }
    //var error : Error!
    
    var mockMovieJsonResponse : [String : Any] = ["status": "ok",
                                                  "totalResults": 34,
                                                  "articles": [[
                                                      "author": "مصراوي",
                                                      "title": "إثيوبيا تُحرض دول حوض النيل لمعارضة خطوات مصر والسودان بشأن سد النهضة - Masrawy-مصراوي",
                                                      "description": "إثيوبيا ت حرض دول حوض النيل لمعارضة خطوات مصر والسودان بشأن سد النهضة | مصراوى",
                                                      "url": "https://www.masrawy.com/news/news_publicaffairs/details/2021/7/7/2052535/إثيوبيا-ت-حرض-دول-حوض-النيل-لمعارضة-خطوات-مصر-والسودان-بشأن-سد-النهضة",
                                                      "urlToImage": "https://media.gemini.media/img/large/2021/6/12/2021_6_12_2_31_26_700.jpg",
                                                      "publishedAt": "2021-07-07T16:49:00Z",
                                                      "content": nil
                                                    ],[
                                                      "author": "سكاي نيوز عربية",
                                                      "title": "بالفيديو.. ميسي يسخر من مدافع كولومبيا بعد إهدار ركلة الجزاء - Sky News Arabia سكاي نيوز عربية",
                                                      "description": "في مباراة دراماتيكية فجر الأربعاء، تنفس ليونيل ميسي الصعداء، بعد تأهل منتخب بلاده الأرجنتين لنهائي بطولة كوبا أميركا على حساب كولومبيا.",
                                                      "url": "https://www.skynewsarabia.com/sport/1449772-%D8%A8%D8%A7%D9%84%D9%81%D9%8A%D8%AF%D9%8A%D9%88-%D9%85%D9%8A%D8%B3%D9%8A-%D9%8A%D8%B3%D8%AE%D8%B1-%D9%85%D8%AF%D8%A7%D9%81%D8%B9-%D9%83%D9%88%D9%84%D9%88%D9%85%D8%A8%D9%8A%D8%A7-%D8%A7%D9%95%D9%87%D8%AF%D8%A7%D8%B1-%D8%B1%D9%83%D9%84%D8%A9-%D8%A7%D9%84%D8%AC%D8%B2%D8%A7%D8%A1",
                                                      "urlToImage": "https://www.skynewsarabia.com/images/v1/2021/07/07/1449771/1200/630/1-1449771.jpg",
                                                      "publishedAt": "2021-07-07T16:44:08Z",
                                                      "content": nil ]]]
                                                    
                                                            
                                                        
}

extension MockNewsService : NewsServiceProtocol{
    func fetchNewsData(completion :@escaping (NewsJsonData?,Error?)->()) {
        var newsData :NewsJsonData!
        do {
            let newsJsonData =   try JSONSerialization.data(withJSONObject: mockMovieJsonResponse, options: .fragmentsAllowed)
            newsData = try JSONDecoder().decode(NewsJsonData.self, from: newsJsonData)
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        if shouldReturnError {
            completion(nil,ResponseErrorEnum.responseError)
        }else{
           completion(newsData,nil)
        }
    }
    
    
}

enum ResponseErrorEnum : Error {
    case responseError
}

