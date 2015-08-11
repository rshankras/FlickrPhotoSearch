//
//  Photo.swift
//  PhotoSearch
//
//  Created by Ravi Shankar on 03/08/15.
//  Copyright (c) 2015 Ravi Shankar. All rights reserved.
//

import UIKit

struct Photo {
    var id: String
    var title: String
    var farm: String
    var secret: String
    var server: String
    var imageURL: NSURL {
        get {
            let url = NSURL(string: "http://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_m.jpg")!
            return url
        }
    }
}