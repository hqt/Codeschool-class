//
//  YelpTableCell.swift
//  Yelp
//
//  Created by Huynh Quang Thao on 3/17/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class YelpTableCell: UITableViewCell {
    
    @IBOutlet weak var dishImageView: UIImageView!
    @IBOutlet weak var dishTitleTextView: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var ratingTextView: UILabel!
    @IBOutlet weak var addressTextView: UILabel!
    @IBOutlet weak var categoriesTextView: UILabel!
    @IBOutlet weak var priceTextView: UILabel!
    @IBOutlet weak var priceUnitTextView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dishImageView.layer.cornerRadius = 3
        dishImageView.clipsToBounds = true
        
        dishTitleTextView.preferredMaxLayoutWidth = dishTitleTextView.frame.size.width
        
    }
    
    override func layoutSubviews() {
        dishTitleTextView.preferredMaxLayoutWidth = dishTitleTextView.frame.size.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
}

}
