//
//  ViewController.swift
//  NEWS App
//
//  Created by Macbook on 28/06/2021.
//

import UIKit
import SDWebImage
import SafariServices
import SwiftyGif


class HomeViewController: UIViewController {
    var orginalArticles = [News]()
    private var articles:[News]?
    var newsViewModel = NewsViewModel()
    var bookmarkNewsViewModel : BookmarkNewsViewModel?
    let logoAnimationView = LogoAnimationView()
    var index = 0
    var filteredNews: [News] = []
    var isSearching = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
  //  @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  tableView.rowHeight = UITableView.automaticDimension
       // tableView.estimatedRowHeight = 300
        articles = [News]()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchBar.searchTextField.delegate = self
        
        newsViewModel.bindNewsViewModelToView = {
                    self.onSuccessUpdateView()
                }
        newsViewModel.bindViewModelErrorToView = {
                    self.onFailUpdateView()
                }
        newsViewModel.bindViewModelNoInternetMessageToView = {
                    self.showInternetMessage()
                }
        bookmarkNewsViewModel = BookmarkNewsViewModel()
//        
//        NetworkManager.isUnreachable { _ in
//            self.showInternetMessage(message: "Cannot Load News")
//        }
        
        view.addSubview(logoAnimationView)
      logoAnimationView.pinEdgesToSuperView()
        logoAnimationView.logoGifImageView.delegate = self
        
        logoAnimationView.logoGifImageView.startAnimatingGif()
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        logoAnimationView.logoGifImageView.startAnimatingGif()
//        self.tabBarController?.tabBar.isHidden = true
    }
    //MARK: - helper functions
    func onSuccessUpdateView(){
        orginalArticles = newsViewModel.newsData.articles
        articles = newsViewModel.newsData.articles
        self.tableView.reloadData()
    }
    func onFailUpdateView(){
        // create the alert
        let alert = UIAlertController(title: "Error", message: newsViewModel.showError, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        // add an action (button)
            alert.addAction(okAction)

            // show the alert
            self.present(alert, animated: true, completion: nil)
    }
    func showInternetMessage() {
        
        let actionsheet = UIAlertController(title: newsViewModel.showMessage, message: "It seems that you are not connected with the internet please reconnect to get all news or go to your bookmarks", preferredStyle: .actionSheet)
        
        actionsheet.addAction(UIAlertAction(title: "Retry", style: .default, handler: {
            action in
//            self.sportsViewModel?.callFuncToGetAllSports(completionHandler: { (isFinished) in
//                if !isFinished {
//                    KRProgressHUD.show()
//                }else {
//                    KRProgressHUD.dismiss()
//                }
//
//            })
            //self.showInternetMessage(message: "Cannot Load news")
            
        }))
        
        actionsheet.addAction(UIAlertAction(title: "Go to bookmarks", style: .default, handler: {
            action in
            self.tabBarController?.selectedIndex = 1
        }))
        
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionsheet, animated: true, completion: nil)
    }
}


extension HomeViewController : UITableViewDelegate , UITableViewDataSource {
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return articles?.count ?? 0
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
       
        cell.newsTitleLabel.text = articles?[indexPath.row].title ?? ""
        
        if let image = self.articles?[indexPath.row].urlToImage {
            cell.newsImageView.sd_setImage(with: URL(string: (image)), placeholderImage: UIImage(named: "noimg"))
        }
        cell.delegate = self
        cell.addIndex(index: indexPath.row)
        return cell
    }
    
//     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 250
//    }
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var websiteUrl = articles?[indexPath.row].url ?? ""
    
        guard let url = URL(string: websiteUrl) else { return }
        
        let config = SFSafariViewController.Configuration()
        let safariController = SFSafariViewController(url: url, configuration: config)
        safariController.modalPresentationStyle = .formSheet
        
        present(safariController, animated: true, completion: nil)
    }
   
}

extension HomeViewController :NewsCellDelegate{
    func addNewsToBookmark(index: Int) {
       // print(allNews[index].title!)
        var title = articles?[index].title ?? ""
        var image = articles?[index].urlToImage ?? ""
        var newsLink = articles?[index].url ?? ""
        bookmarkNewsViewModel?.callFuncToAddNewsToCoreData(title: title, img: image, newsLink: newsLink)
       
    }
    
   
    
}
extension HomeViewController: SwiftyGifDelegate {
    func gifDidStop(sender: UIImageView) {
        logoAnimationView.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }
}
extension HomeViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        articles = newsViewModel.search(articles: orginalArticles , searchText: searchText)
        tableView.reloadData()
    }
}
extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.endEditing(true)
    }
}
