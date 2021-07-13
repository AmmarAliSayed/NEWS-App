//
//  BookmarkNewsViewModel.swift
//  NEWS App
//
//  Created by Macbook on 29/06/2021.
//

import Foundation
import CoreData
import UIKit

class BookmarkNewsViewModel: NSObject {
    
    //property to get the data when success
    var BookmarkNewsCoreData: [NSManagedObject]!
       
    var filterdBookmarkNewsCoreData: [NSManagedObject]!
    let manageContext: NSManagedObjectContext
  //  let manageContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   // let  manageContext: NSManagedObjectContext = CoreDataStack.shared.mainContext
    init(mainContext: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.manageContext = mainContext
    }
    func callFuncToAddNewsToCoreData(title:String,img:String,newsLink:String){
        
        let entity = NSEntityDescription.entity(forEntityName: "BookmarkNews", in: manageContext)
        
        // 4 create manage object for movie entity
        
        let BookmarkNews = NSManagedObject(entity: entity!, insertInto: manageContext)
        
        //5 set values for the manage object
        
        BookmarkNews.setValue(title, forKey: "title")
        BookmarkNews.setValue(img, forKey: "image")
        BookmarkNews.setValue(newsLink, forKey: "url")
        do{
            try manageContext.save()
            BookmarkNewsCoreData?.append(BookmarkNews)
        }catch let error{
            print(error)
        }
    }
    
    func callFuncToFetchDataFromCoreData() {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "BookmarkNews")
        
        do{
            BookmarkNewsCoreData = try manageContext.fetch(fetchRequest)
        }catch let error{
            print(error)
        }
    }
    
    func deleteFromCoreData(with url: String) {

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "BookmarkNews")
        let predicate = NSPredicate(format: "url == %@", url)
        fetchRequest.predicate = predicate

        if let result = try? manageContext.fetch(fetchRequest) {
            for object in result {
                manageContext.delete(object)
                try? manageContext.save()
            }
        }

    }
    
    func searchInCoreData(with title: String) {

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "BookmarkNews")
        let predicate = NSPredicate(format: "title contains[cd] %@", title)
        fetchRequest.predicate = predicate

        do{
            filterdBookmarkNewsCoreData = try manageContext.fetch(fetchRequest)
        }catch let error{
            print(error)
        }

    }
    
//    var results: [NSManagedObject] = []
//
//    func checkLeagueExists (leagueId :String) -> Bool {
//
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "BookmarkNews")
//
//        let predicate = NSPredicate(format: "favoriteLeagueId == %@", leagueId)
//
//        fetchRequest.predicate = predicate
//
//        do {
//            results = try manageContext.fetch(fetchRequest)
//        }
//        catch {
//            print("error executing fetch request: \(error)")
//        }
//        return results.count > 0
//    }

   
    
}
