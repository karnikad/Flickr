//
//  FlickrImage.swift
//  Flickr
//
//  Created by Karnika Advani on 24/06/18.
//  Copyright © 2018 Karnika Advani. All rights reserved.
//

import Foundation

let IMG_URL_TEMPLATE = "https://farm%d.static.flickr.com/%@/%@_%@.jpg"

public struct FlickrImage: Codable {
  public var id : String!
  public var farm: Int!
  public var server: String!
  public var secret: String!
  
  public func getImageURL() -> URL {
    let urlString = String(format: IMG_URL_TEMPLATE, farm, server, id, secret)
    return URL(string: urlString)!
  }
  
  
}
