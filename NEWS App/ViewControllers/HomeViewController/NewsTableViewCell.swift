//
//  NewsTableViewCell.swift
//  NEWS App
//
//  Created by Macbook on 28/06/2021.
//

import UIKit
protocol NewsCellDelegate: class {
    func addNewsToBookmark(index : Int)
}
class NewsTableViewCell: UITableViewCell {
    weak var delegate: NewsCellDelegate?
    var cellIndex = 0
    @IBOutlet weak var containerView: UIView!
   // @IBOutlet weak var bookMarkButtonOutlet: UIImageView!
    @IBOutlet weak var bookMarkButtonOutlet: UIButton!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func bookMarkButtonPressed(_ sender: Any) {
        delegate?.addNewsToBookmark(index: cellIndex)
        let btnImage = UIImage(systemName: "heart.fill")
        //bookMarkButtonOutlet.tintColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        bookMarkButtonOutlet.setImage(btnImage, for: .normal)
       
        
    }
    func addIndex(index : Int){
        cellIndex = index
    }
}
