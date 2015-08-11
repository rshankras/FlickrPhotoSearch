//
//  DetailViewController.swift
//  FlickrPhotoSearch
//
//  Created by Ravi Shankar on 04/08/15.
//  Copyright (c) 2015 Ravi Shankar. All rights reserved.
//

import UIKit
import Haneke

class DetailViewController: UIViewController {
    
    var photo:Photo?
    var imageView:UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let photo = photo {
            
            imageView = UIImageView(frame: CGRectMake(0, 0, 320, 320))
            imageView?.hnk_setImageFromURL(photo.imageURL)
            view.addSubview(imageView!)
            
            let tapGestureRecogonizer = UITapGestureRecognizer(target: self, action: Selector("close"))
            view.addGestureRecognizer(tapGestureRecogonizer)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- viewDidLayoutSubviews
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let size = view.bounds.size
        let imageSize = CGSizeMake(size.width,size.width)
        imageView?.frame = CGRectMake(0.0, (size.height - imageSize.height)/2.0, imageSize.width, imageSize.height)
        
    }
    
    // MARK:- close
    
    func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
