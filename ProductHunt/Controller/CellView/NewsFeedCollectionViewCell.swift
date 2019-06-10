//
//  NewsFeedCollectionViewCell.swift
//  ProductHunt
//
//  Created by Apple on 07/06/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class NewsFeedCollectionViewCell: UICollectionViewCell {
     @IBOutlet weak var lblPostName: UILabel!
     @IBOutlet weak var lblPostTagline: UILabel!
     @IBOutlet weak var imgPost: UIImageView!
     @IBOutlet weak var txtViewDescription: UITextView!
     @IBOutlet weak var btnVoteCount: UIButton!
     @IBOutlet weak var btnCommentCount: UIButton!
}
