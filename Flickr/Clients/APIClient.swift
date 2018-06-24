//
//  APIClient.swift
//  Flickr
//
//  Created by Karnika Advani on 24/06/18.
//  Copyright © 2018 Karnika Advani. All rights reserved.
//

import Foundation

let BASE_URL = "https://api.flickr.com/services/rest/"

class APIClient {
  
  let decoder: JSONDecoder
  
  init(with decoder:JSONDecoder){
    self.decoder = JSONDecoder()
  }
  
  static let defaultClient: APIClient = {
    let defaultClient = APIClient(with: JSONDecoder())
    return defaultClient
  }()
  
  func request(_ url:String, method:String, params:[String:Any?]?, headers:[String:String]?, body: Data?, complete: @escaping (Any?,Error?) -> Void){
    let fullUrl = BASE_URL + url + "?" + self.urlEncode(params: params)
    var urlRequest = URLRequest(url: URL(string: fullUrl)!)
    urlRequest.httpMethod = method.uppercased()
    urlRequest.allHTTPHeaderFields = headers
    urlRequest.httpBody = body
    URLSession.shared.dataTask(with: urlRequest) { data, response, error in
      guard
        let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
        let _ = data
        else { return }
      complete(data,error)
      }.resume()
    
  }
  
  func urlEncode(params:[String:Any?]?) -> String{
    guard let params = params else { return ""}
    var encodedParams = ""
    for (key,value) in params {
      encodedParams += key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! + "="
      encodedParams += String(describing: value!).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! + "&"
    }
    return encodedParams
  }
  
  func getPhotosFor(_ keyword:String, pageNumber:Int?, perPage:Int?, complete: @escaping (FlickrAPIResults?,Error?) -> Void){
    let urlParams = [
      "method":"flickr.photos.search",
      "api_key":"3e7cc266ae2b0e0d78e279ce8e361736",
      "format":"json",
      "nojsoncallback":1,
      "safe_search":1,
      "text":keyword
      ] as [String : Any]
    self.request("", method: "GET", params: urlParams, headers: nil, body: nil) { (data, error) in
      if let error = error {
        NSLog("Error occurred - Details: %@", String(describing: error))
        complete(nil,error)
      }
      else {
        do {
          if let result = try self.decoder.decode(FlickrAPIResults.self, from: data as! Data, keyPath: "photos") as FlickrAPIResults? {
            DispatchQueue.main.async() {
              complete(result,nil)
            }
          } else {
            NSLog("Error occurred in parsing data")
          }
        } catch let error {
          complete(nil,error)
        }
      }
    }
  }
  
  func cancelAllRequests(){
    URLSession.shared.invalidateAndCancel()
  }
}

