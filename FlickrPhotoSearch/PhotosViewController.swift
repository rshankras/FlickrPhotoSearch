//
//  ViewController.swift
//  FlickrPhotoSearch
//
//  Created by Ravi Shankar on 04/08/15.
//  Copyright (c) 2015 Ravi Shankar. All rights reserved.
//

import UIKit
import Haneke

class PhotosViewController: UIViewController, UISearchBarDelegate, FlickrPhotoDownloadDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var service:Services = Services()
    var photos: [Photo] = [Photo]()
    
    let reuseIdentifier = "PhotoCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        searchBar.delegate = self
        collectionView.delegate = self
        service.delegate = self
        
        // default
        searchBar.text = "famous quotes"
        searchForPhotos()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- SearchButton
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchForPhotos()
        searchBar .resignFirstResponder()
    }
    
    // MARK:- SearchPhotos
    
    func searchForPhotos() {
        service.makeServiceCall(searchBar.text!)
    }
    
    // MARK:- Flickr Photo Download
    func finishedDownloading(photos: [Photo]) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.photos = photos
            self.collectionView?.reloadData()
            
        })
    }
}

extension PhotosViewController: UICollectionViewDataSource {
    // MARK:- UICollectionViewDataSource methods
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! PhotoCell
        let photo = photos[indexPath.row]
        cell.imageView.frame.size = cell.frame.size
        cell.imageView.hnk_setImageFromURL(photo.imageURL)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let photo:Photo? = photos[indexPath.row]
        if let photo = photo {
            let detailViewController = storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
            detailViewController.photo = photo
            presentViewController(detailViewController, animated: true, completion: nil)
        }
    }
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    // MARK:- UICollectioViewDelegateFlowLayout methods
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        // http://stackoverflow.com/questions/28872001/uicollectionview-cell-spacing-based-on-device-sceen-size
        
        let length = (UIScreen.mainScreen().bounds.width-15)/4
        return CGSizeMake(length,length);
    }
}

