//
//  FlickrPhotoCell.swift
//  BehindMe
//
//  Created by Ashok Kumar on 6/24/16.
//  Copyright © 2016 AshokKumarDeva. All rights reserved.
//

import UIKit

class FlickrPhotoCell: UICollectionViewCell {
    
    @IBOutlet var photoDetailLabel: UILabel!
    @IBOutlet var photoImageView: UIImageView!
    
    @IBOutlet var photoDetailView: UIView!
    
    var isFlipped:Bool!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
}
