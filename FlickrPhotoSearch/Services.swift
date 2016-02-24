//
//  Services.swift
//  PhotoSearch
//
//  Created by Ravi Shankar on 03/08/15.
//  Copyright (c) 2015 Ravi Shankar. All rights reserved.
//

import Alamofire
import SwiftyJSON

protocol FlickrPhotoDownloadDelegate: class {
    func finishedDownloading(photos:[Photo])
}

class Services {
    
    let API_KEY = "YOUR_API_KEY"
    let URL = "https://api.flickr.com/services/rest/"
    let METHOD = "flickr.photos.search"
    let FORMAT_TYPE:String = "json"
    let JSON_CALLBACK:Int = 1
    let PRIVACY_FILTER:Int = 1
    
    weak var delegate:FlickrPhotoDownloadDelegate?
    
    // MARK:- Service Call
    
    func makeServiceCall(searchText: String) {
        Alamofire.request(.GET, URL, parameters: ["method": METHOD, "api_key": API_KEY, "tags":searchText,"privacy_filter":PRIVACY_FILTER, "format":FORMAT_TYPE, "nojsoncallback": JSON_CALLBACK]).responseJSON { (response) -> Void in
            
            switch response.result {
            case .Success(let data):
                let jsonData:JSON = JSON(data)
                let photosDict = jsonData["photos"]
                let photoArray = photosDict["photo"]
                var photos = [Photo]()
                
                for item in photoArray  {
                    let id = item.1["id"].stringValue
                    let farm = item.1["farm"].stringValue
                    let server = item.1["server"].stringValue
                    let secret = item.1["secret"].stringValue
                    let title = item.1["title"].stringValue
                    let photo = Photo(id:id, title:title, farm:farm, secret: secret, server: server)
                    photos.append(photo)
                }
                self.delegate?.finishedDownloading(photos)
            case .Failure(let error):
                print("Request failed with error: \(error)")
            }
            
            
        }
    }
}