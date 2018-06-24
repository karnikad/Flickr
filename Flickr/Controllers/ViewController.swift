//
//  ViewController.swift
//  Flickr
//
//  Created by Karnika Advani on 22/06/18.
//  Copyright © 2018 Karnika Advani. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, UICollectionViewDelegateFlowLayout {

  @IBOutlet var masterView: UIView!
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var collectionView: UICollectionView!

  @IBOutlet weak var collectionViewLayout: UICollectionViewFlowLayout!
  
  var imagesArray = [FlickrImage]()
  var isLoading = true
  var currentResults: FlickrAPIResults?
  var keyword = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view, typically from a nib.
    searchBar.delegate = self
    collectionView.delegate = self
    collectionView.dataSource = self
    self.resetState()
  }
  
  @IBOutlet weak var initialView: UIView!
  

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


  //mark - UICollectionViewDatasource methods
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return imagesArray.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell:FlickrImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FlickrImageCollectionViewCell.self), for: indexPath) as! FlickrImageCollectionViewCell
    cell.setImage(link:self.imagesArray[indexPath.row].getImageURL())
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    // The calculation is the content size minus all offsets which is 30(5+10+10+5)
    let width = (self.collectionView.contentSize.width - 30) / 3;
    return CGSize(width: width, height: width)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    return CGSize(width: self.collectionView.contentSize.width, height: self.isLoading ? 60 : 0);
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: UICollectionElementKindSectionFooter, for: indexPath);
    return footer;
  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    if indexPath.row == 0 { return }
    guard self.currentResults != nil else {
      return
    }
    if indexPath.row == (self.imagesArray.count - 1) {
      if(!isLoading){
        self.loadNextPage()
      }
    }
  }
  
  //mark - searchbar delegate functions
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let currentKeyword = searchBar.text else { return }
    if(self.isLoading || self.keyword != currentKeyword){
      self.resetState()
    }
    if currentKeyword.count > 0 {
      self.keyword = currentKeyword
      self.loadData()
    }
    searchBar.endEditing(true)
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    self.resetState()
  }
  
  
  //mark - private functions
  func loadData() {
    self.showDataFor(pageNumber: nil, perPage: nil)
  }
  
  func loadNextPage(){
    guard let results = self.currentResults else { return }
    if(results.page == results.pages){
      self.showToast(message: "No more results")
      return
    }
    self.showDataFor(pageNumber: results.page + 1 , perPage: nil)
  }
  
  func showDataFor(pageNumber: Int?, perPage: Int?){
    self.showLoading();
    APIClient.defaultClient.getPhotosFor(self.keyword, pageNumber: pageNumber, perPage: perPage) { (result, error) in
      self.hideLoading();
      if let error = error {
        self.showToast(message: String(format: "Error occourred %@", error.localizedDescription))
        return
      }
      if self.currentResults != nil {
        self.imagesArray.append(contentsOf: result!.photo)
      } else {
        self.imagesArray = result!.photo
      }
      self.currentResults = result!
      self.collectionView.reloadData()
    }
  }
  
  func showLoading(){
    self.isLoading = true
    self.initialView.isHidden = true
    self.collectionViewLayout.invalidateLayout()
  }
  
  func hideLoading(){
    self.isLoading = false
    self.collectionViewLayout.invalidateLayout()
  }
  
  func resetState(){
    APIClient.defaultClient.cancelAllRequests()
    self.initialView.isHidden = false
    self.isLoading = false
    self.imagesArray.removeAll()
    self.collectionView.reloadData()
    self.currentResults = nil
  }
}

