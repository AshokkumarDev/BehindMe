//
//  FlickrPhotosViewController.swift
//  BehindMe
//
//  Created by Ashok Kumar on 6/24/16.
//  Copyright © 2016 AshokKumarDeva. All rights reserved.
//

import UIKit



class FlickrPhotosViewController: UICollectionViewController {

    
    private let reuseIdentifier = "FlickrCell"
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    
    private var searches = [FlickrSearchResults]()
    private let flickr = Flickr()
    
    func photoForIndexPath(indexPath: NSIndexPath) -> FlickrPhoto {
        return searches[indexPath.section].searchResults[indexPath.row]
    }
    
    
}

extension FlickrPhotosViewController : UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // 1
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        textField.addSubview(activityIndicator)
        activityIndicator.frame = textField.bounds
        activityIndicator.startAnimating()
        flickr.searchFlickrForTerm(textField.text!) {
            results, error in
            
            //2
            activityIndicator.removeFromSuperview()
            if error != nil {
                print("Error searching : \(error)")
            }
            
            if results != nil {
                //3
                print("Found \(results!.searchResults.count) matching \(results!.searchTerm)")
                self.searches.insert(results!, atIndex: 0)
                
                //4
                self.collectionView?.reloadData()
            }
        }
        
        textField.text = nil
        textField.resignFirstResponder()
        return true
    }
}

extension FlickrPhotosViewController : UICollectionViewDelegateFlowLayout {
    //1
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let flickrPhoto =  photoForIndexPath(indexPath)
        //2
        /*if var size = flickrPhoto.thumbnail?.size {
            size.width += 10
            size.height += 10
            return size
        }*/
        return CGSize(width: 200, height: 200)
    }
    
    //3
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
}

extension FlickrPhotosViewController  {
    
    //1
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return searches.count
    }
    
    //2
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searches[section].searchResults.count
    }
    
    //3
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! FlickrPhotoCell
        //2
        let flickrPhoto = photoForIndexPath(indexPath)
        cell.backgroundColor = UIColor.blackColor()
        //3
        cell.photoDetailView.hidden = true
        cell.photoImageView.hidden = false
        cell.isFlipped = false
        cell.photoImageView.image = flickrPhoto.thumbnail
        cell.photoDetailLabel.sizeToFit()
        cell.photoDetailLabel.text = flickrPhoto.title
        
        return cell
    }
    
   /* override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Header", forIndexPath: indexPath) as! CollectionHeaderReusableView
            headerView.dateLabel.text = searches[indexPath.section].searchTerm
            return headerView
            
        case UICollectionElementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Footer", forIndexPath: indexPath) 
            
            footerView.backgroundColor = UIColor.greenColor();
            return footerView
            
        default:
            
            assert(false, "Unexpected element kind")
        }
    }*/
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell:FlickrPhotoCell = collectionView.cellForItemAtIndexPath(indexPath) as! FlickrPhotoCell
        self.flipView(cell)
        //cell.photoImageView.hidden = true
        //cell.photoDetailView.hidden = false
    }
    
    func flipView(cellToFlick: FlickrPhotoCell)
    {
        let transitionOptions: UIViewAnimationOptions = [.TransitionFlipFromTop, .ShowHideTransitionViews]
        
        UIView.transitionWithView(cellToFlick.photoImageView, duration: 1.0, options: transitionOptions, animations: {
            if(!cellToFlick.isFlipped)
            {
                cellToFlick.photoImageView.hidden = true
                
            }
            else
            {
               
               cellToFlick.photoImageView.hidden = false
            }
        }, completion: nil)
        
        UIView.transitionWithView( cellToFlick.photoDetailView, duration: 1.0, options: transitionOptions, animations: {
            if(!cellToFlick.isFlipped)
            {
                cellToFlick.photoDetailView.hidden = false
                cellToFlick.isFlipped = true
            }
            else
            {
                cellToFlick.photoDetailView.hidden = true
                cellToFlick.isFlipped = false
            }
        }, completion: nil)
    }
}
