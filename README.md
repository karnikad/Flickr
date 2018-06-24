# Flickr
iOS application to search images through Flickr.

### Requirements
Flickr is written with Swift 4 and is compatible with iOS 11.

### Components

#### Model
###### FlickrImage
FlickrImage represents each image object obtained in the results of the flickr photo search api.
###### FlickrAPIResults
FlickrAPIResult is the entire result, which contains other metadata like number of items got per page, page number etc.

#### View
###### Main.storyboard
Main.storybord has the collection view with embedded cell and search bar.
###### CollectionViewCells
FlickrImageCollectionViewCell shows the image in the cell.

#### Controller
Controller contains the functionality to display images in the collection view after the user searches by typing in the search bar.

#### Extensions
###### UIImage+Extension
Helps in downloading image from url and sets it onto the image view.
###### JSONDecoder+FromKeyPath
This class decodes json from a particular keypath.
###### UIViewController+Toast
This class helps in implementing the toast.

#### Clients
###### APIClient
APIClient is the class which deals with the Flickr api.


### License
Flickr is available under the MIT license. See the LICENSE file for more info.
