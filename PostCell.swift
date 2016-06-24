//
//  PostCell.swift
//  ParsePics
//
//  Created by Amy Xiong on 6/23/16.
//  Copyright © 2016 Amy Xiong. All rights reserved.
//

import UIKit
import ParseUI

class PostCell: UITableViewCell {

    @IBOutlet weak var photoView: PFImageView!
    
    var post: PFObject! {
        didSet {
            self.photoView.file = post["media"] as? PFFile
            self.photoView.loadInBackground()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
