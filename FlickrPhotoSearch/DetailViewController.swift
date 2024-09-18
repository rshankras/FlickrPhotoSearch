//
//  DetailViewController.swift
//  FlickrPhotoSearch
//
//  Created by Ravi Shankar on 04/08/15.
//  Copyright (c) 2015 Ravi Shankar. All rights reserved.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {
    
    var photo:Photo?
    var imageView:UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let photo = photo {
            imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 320, height: 320))
            if let url = URL(string: photo.largeImageURL) {
                imageView?.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
                view.addSubview(imageView!)
                
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(close))
                view.addGestureRecognizer(tapGestureRecognizer)
            }
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
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
}
