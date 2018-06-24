//
//  FlickerAPIResults.swift
//  Flickr
//
//  Created by Karnika Advani on 24/06/18.
//  Copyright © 2018 Karnika Advani. All rights reserved.
//

import Foundation

public struct FlickrAPIResults: Codable {
  public var page : Int!
  public var pages: Int!
  public var perPage: Int!
  public var total: String!
  public var photo: [FlickrImage]!
}
