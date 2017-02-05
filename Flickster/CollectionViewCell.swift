//
//  CollectionViewCell.swift
//  Flickster
//
//  Created by Ryan Liszewski on 2/2/17.
//  Copyright © 2017 Smiley. All rights reserved.
//

import UIKit
import Cosmos


class CollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet var cosmosView: CosmosView!
    @IBOutlet weak var photoViewCell: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    //@IBOutlet weak var shareIconImageView: UIImageView!
    @IBOutlet weak var favoriteIconImageView: UIImageView!
}
