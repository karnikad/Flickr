//
//  FlickrImageCollectionViewCell.swift
//  Flickr
//
//  Created by Karnika Advani on 24/06/18.
//  Copyright © 2018 Karnika Advani. All rights reserved.
//

import Foundation
import UIKit

class FlickrImageCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var imageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  public func setImage(link: URL) {
    self.imageView.setImage(url:link)
  }
  
}
