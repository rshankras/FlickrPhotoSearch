//
//  ViewController.swift
//  FlickrPhotoSearch
//
//  Created by Ravi Shankar on 04/08/15.
//  Copyright (c) 2015 Ravi Shankar. All rights reserved.
//

import UIKit
import SDWebImage

class PhotosViewController: UIViewController, UISearchBarDelegate, PixabayPhotoDownloadDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var service: Services = Services()
    var photos: [Photo] = []
    
    let reuseIdentifier = "PhotoCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        searchBar.delegate = self
        collectionView.delegate = self
        service.delegate = self
        
        // default
        searchBar.text = "nature"
        searchForPhotos()
    }

    // MARK:- SearchButton
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchForPhotos()
        searchBar.resignFirstResponder()
    }
    
    // MARK:- SearchPhotos
    
    func searchForPhotos() {
        service.makeServiceCall(searchText: searchBar.text!)
    }
    
    // MARK:- Pixabay Photo Download
    func finishedDownloading(photos: [Photo]) {
        DispatchQueue.main.async {
            self.photos = photos
            self.collectionView?.reloadData()
        }
    }
}

extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCell
        let photo = photos[indexPath.row]

        // Set the imageView frame size to match the cell size
        cell.imageView.frame.size = cell.frame.size

        // Use SDWebImage to load the image asynchronously and cache it
        if let url = URL(string: photo.previewURL) {
            cell.imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        let detailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailViewController.photo = photo
        present(detailViewController, animated: true, completion: nil)
    }
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    // MARK:- UICollectioViewDelegateFlowLayout methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // http://stackoverflow.com/questions/28872001/uicollectionview-cell-spacing-based-on-device-sceen-size
        
        let length = (UIScreen.main.bounds.width-15)/4
        return CGSizeMake(length,length);
    }
}

