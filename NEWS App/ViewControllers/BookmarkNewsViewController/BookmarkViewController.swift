//
//  BookmarkViewController.swift
//  NEWS App
//
//  Created by Macbook on 10/07/2021.
//

import UIKit
import SafariServices

class BookmarkViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
   // var filteredNews:[Dictionary<String, Any>] = []
    var isSearching = false
    
    var bookmarkNewsViewModel : BookmarkNewsViewModel?
   // var allNews: [Dictionary<String, Any>] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        bookmarkNewsViewModel = BookmarkNewsViewModel()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //print("gggggggggggggggggggg")
        bookmarkNewsViewModel?.callFuncToFetchDataFromCoreData()
        
        tableView.reloadData()
        
       // leagueViewModel = LeaguesViewModel()
        
}
  

}
extension BookmarkViewController : UITableViewDelegate , UITableViewDataSource {
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (isSearching) {
            return   bookmarkNewsViewModel?.filterdBookmarkNewsCoreData.count ?? 0
           }
           else {
            return bookmarkNewsViewModel?.BookmarkNewsCoreData.count ?? 0
           }
        
    }

    
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NewsTableViewCell.self), for: indexPath) as? NewsTableViewCell else {
            return UITableViewCell()
        }
        cell.newsImageView.layer.cornerRadius = 20
        cell.newsImageView.clipsToBounds = true
        // the shadow is gonna be to containerView and the image view is gonna be inside that containerView
        // can't do the shadow to the image view because of the clips to bounds is set to true
        cell.containerView.translatesAutoresizingMaskIntoConstraints = false
        cell.containerView.backgroundColor = .clear
        cell.containerView.layer.shadowColor = UIColor.black.cgColor
        cell.containerView.layer.shadowOffset = CGSize.zero
        cell.containerView.layer.shadowOpacity = 0.7
        cell.containerView.layer.shadowRadius = 5.0
        cell.containerView.layer.masksToBounds = false
        cell.containerView.clipsToBounds = false

        if isSearching {
         cell.newsImageView.sd_setImage(with: URL(string: (  bookmarkNewsViewModel?.filterdBookmarkNewsCoreData![indexPath.row].value(forKey: "image") as? String ?? "")) ,  placeholderImage: UIImage(named: "placeholderAsset"))
            cell.newsTitleLabel.text =
                bookmarkNewsViewModel?.filterdBookmarkNewsCoreData![indexPath.row].value(forKey: "title") as? String
              
            

        }else{
            cell.newsImageView.sd_setImage(with: URL(string: (  bookmarkNewsViewModel?.BookmarkNewsCoreData![indexPath.row].value(forKey: "image") as? String ?? "")) ,  placeholderImage: UIImage(named: "placeholderAsset"))
             cell.newsTitleLabel.text =
                 bookmarkNewsViewModel?.BookmarkNewsCoreData![indexPath.row].value(forKey: "title") as? String
        }
        

        return cell
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let url = bookmarkNewsViewModel?.BookmarkNewsCoreData![indexPath.row].value(forKey: "url") as? String
        
        if editingStyle == .delete {
            if let myUrl = url {
                bookmarkNewsViewModel?.deleteFromCoreData(with: myUrl)
                
                tableView.reloadData()
            }
            bookmarkNewsViewModel?.BookmarkNewsCoreData!.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
      
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       tableView.deselectRow(at: indexPath, animated: true)
     
        
        NetworkManager.isUnreachable { _ in
            let alert = UIAlertController(title: "Can't open URL", message: "It seems that you are not connected with the internet please reconnect and retry later", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        NetworkManager.isReachable { [self] (NetworkManager) in
            
           var websiteUrl = bookmarkNewsViewModel?.BookmarkNewsCoreData![indexPath.row].value(forKey: "url") as? String ?? ""
       
           guard let url = URL(string: websiteUrl) else { return }
           
           let config = SFSafariViewController.Configuration()
           let safariController = SFSafariViewController(url: url, configuration: config)
           safariController.modalPresentationStyle = .formSheet
           
           present(safariController, animated: true, completion: nil)
        }
        
        
        
   }


   
}
extension BookmarkViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText.count != 0) {
            isSearching = true
            bookmarkNewsViewModel?.searchInCoreData(with: searchText)
        }else{
           // self.hideLoadingIndicator()
            isSearching = false
        }
        self.tableView.reloadData()
    
      }
    }
     
