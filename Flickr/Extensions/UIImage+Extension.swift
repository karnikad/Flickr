//
//  UIImage+Extension.swift
//  Flickr
//
//  Created by Karnika Advani on 23/06/18.
//  Copyright © 2018 Karnika Advani. All rights reserved.
//

import Foundation
import UIKit

public extension UIImageView {
  func setImage(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
    contentMode = mode

    URLSession.shared.dataTask(with: url) { data, response, error in
      guard
        let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
        let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
        let data = data, error == nil,
        let image = UIImage(data: data)
        else { return }
      DispatchQueue.main.async() {
        self.image = image
      }
      }.resume()
  }
  func setImage(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
    guard let url = URL(string: link) else { return }
    setImage(url: url, contentMode: mode)
  }
}
