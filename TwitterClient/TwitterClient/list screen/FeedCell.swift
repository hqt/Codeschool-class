//
//  FeedCellTableViewCell.swift
//  TwitterClient
//
//  Created by Huynh Quang Thao on 3/26/16.
//  Copyright © 2016 Huynh Quang Thao. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {

    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var casualnameTextView: UILabel!
    
    @IBOutlet weak var usernameTextView: UILabel!
    
    @IBOutlet weak var timeTextView: UILabel!
    
    @IBOutlet weak var contentTextView: UILabel!
    
    @IBOutlet weak var favouriteImageView: UIImageView!
    
    @IBOutlet weak var totalRetweetTextView: UILabel!
    
    @IBOutlet weak var retweetImageView: UIImageView!
    
    @IBOutlet weak var totalFavTextView: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
