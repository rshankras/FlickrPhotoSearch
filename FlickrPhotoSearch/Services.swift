//
//  Services.swift
//  PhotoSearch
//
//  Created by Ravi Shankar on 03/08/15.
//  Copyright (c) 2015 Ravi Shankar. All rights reserved.
//

import Alamofire
import SwiftyJSON

class Services {
    
    // Pixabay API details
    let API_KEY = "YOUR_API_KEY_HERE"
    let URL = "https://pixabay.com/api/"
    
    weak var delegate: PixabayPhotoDownloadDelegate?
    
    // MARK:- Service Call
    
    func makeServiceCall(searchText: String) {
        // Parameters for the Pixabay API call
        let parameters: [String: Any] = [
            "key": API_KEY,
            "q": searchText,
            "per_page": 200 // You can adjust the number of results per page if needed
        ]
        
        // Alamofire request to Pixabay API
        AF.request(URL, method: .get, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let photos = json["hits"].arrayValue.map { Photo(json: $0) }
                self.delegate?.finishedDownloading(photos: photos)
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
}

// Model for Pixabay photo
struct Photo {
    let id: Int
    let pageURL: String
    let previewURL: String
    let largeImageURL: String
    
    init(json: JSON) {
        id = json["id"].intValue
        pageURL = json["pageURL"].stringValue
        previewURL = json["previewURL"].stringValue
        largeImageURL = json["largeImageURL"].stringValue
    }
}

// Delegate protocol
protocol PixabayPhotoDownloadDelegate: AnyObject {
    func finishedDownloading(photos: [Photo])
}
