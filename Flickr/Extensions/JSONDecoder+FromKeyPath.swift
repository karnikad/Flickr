//
//  JSONDecoder+FromKeyPath.swift
//  Flickr
//
//  Created by Karnika Advani on 24/06/18.
//  Copyright © 2018 Karnika Advani. All rights reserved.
//

import Foundation

public extension JSONDecoder {
  public func decode<T: Decodable>(_ type: T.Type, from data: Data, keyPath: String) throws -> T {
    let toplevel = try JSONSerialization.jsonObject(with: data)
    if let nestedJson = (toplevel as AnyObject).value(forKeyPath: keyPath) {
      let nestedJsonData = try JSONSerialization.data(withJSONObject: nestedJson)
      return try decode(type, from: nestedJsonData)
    } else {
      throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Nested json not found for key path \"\(keyPath)\""))
    }
  }
}
