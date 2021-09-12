//
//  NewsViewModel.swift
//  NEWS App
//
//  Created by Macbook on 28/06/2021.
//

import Foundation
class NewsViewModel: NSObject {
    //property from model
    var newsService : NewsService!
    //property to get the data when success
    var newsData : NewsJsonData!{
        didSet{
            //we add listener her so when we set the employeeData property we will call
            //bindEmplyeesViewModelToView() function type so this is a callback because I do not know when
            //the data come ->Asynchronous
            self.bindNewsViewModelToView()
        }
    }
    //property when the error happened
    var showError : String!{
        didSet{
            //we add listener her so when we set the showError property we will call
            //bindViewModelErrorToView() function type
            self.bindViewModelErrorToView()
        }
    }
    
    //property when the error happened
    var showMessage : String!{
        didSet{
            //we add listener her so when we set the showError property we will call
            //bindViewModelErrorToView() function type
            self.bindViewModelNoInternetMessageToView()
        }
    }
    //two functions type - two properties
    var bindNewsViewModelToView : (()->()) = {}
    var bindViewModelErrorToView : (()->()) = {}
    var bindViewModelNoInternetMessageToView : (()->()) = {}
    //inilizer
    override init() {
        super.init()
        self.newsService = NewsService()
        self.fetchNewsDataFromApi()
    }
    
    func fetchNewsDataFromApi(){
        newsService.fetchNewsData { (newsData, error) in
            if let error :Error = error{
                let message = error.localizedDescription
                if error.asAFError?.responseCode == -1 {
                    self.showMessage = "No Internet"
                }else{
                    self.showError = message
                }
                
                
            }else{
                self.newsData = newsData
            }
        }
    }
    func search(articles:[News],searchText:String)->[News]{
        return searchText.isEmpty ? articles : articles.filter({
            (data:News)->Bool in
            return data.title?.range(of: searchText, options: .caseInsensitive) != nil
        })
    }
}
