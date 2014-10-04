//
//  CSImageGalleryViewController.swift
//  MultiPhotoPicker
//
//  Created by Sailender Singh on 20/09/14.
//  Copyright (c) 2014 Sailender Singh. All rights reserved.
//

import Foundation
import UIKit
import AssetsLibrary

class CSImageGalleryViewController:  UIViewController {
    
    typealias completionCallback = (images: NSArray) -> Void
    
    private var selectedImages: NSMutableArray?=nil
    private var scrollView: UIScrollView?=nil
    private var allPhotoAssets: NSMutableArray?=nil
    private var callback: completionCallback?=nil
    
    class var assetLibrary:ALAssetsLibrary {
        get {
            struct Static {
                static var instance : ALAssetsLibrary? = nil
                static var token : dispatch_once_t = 0
            }
            
            dispatch_once(&Static.token) {
                Static.instance = ALAssetsLibrary()
            }
            
            return Static.instance!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Image Gallery"
        selectedImages = NSMutableArray();
        scrollView = UIScrollView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
        self.view.addSubview(scrollView!)
        let leftBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancelButtonTapped:")
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        let rightBarButton = UIBarButtonItem(title: "Select", style: UIBarButtonItemStyle.Plain, target: self, action: "selectButtonTapped:")
        self.navigationItem.rightBarButtonItem = rightBarButton
        self.navigationItem.rightBarButtonItem?.enabled = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        self.fetchPhotoLibraryImages()
    }
    
    private func fetchPhotoLibraryImages() {
        allPhotoAssets = NSMutableArray()
        self.fetchPhotoLibraryGroups()
    }
    
    private func fetchPhotoLibraryGroups() {
        
        var assetGroupEnumerator: ALAssetsLibraryGroupsEnumerationResultsBlock = {(group: ALAssetsGroup!, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
            
            if (group? != nil) {
                self.loadPhotosFromGroup(group!)
            }
            
        }
        
        var enumeratorFailureBlock: ALAssetsLibraryAccessFailureBlock = { (error: NSError!) -> Void in
            println(error)
        }

        CSImageGalleryViewController.assetLibrary.enumerateGroupsWithTypes(ALAssetsGroupType(ALAssetsGroupAll), usingBlock: assetGroupEnumerator, failureBlock: enumeratorFailureBlock)
    }
    
    private func loadPhotosFromGroup(group: ALAssetsGroup) {
        group.setAssetsFilter(ALAssetsFilter.allPhotos())
        group.enumerateAssetsUsingBlock { (asset: ALAsset!,index: Int, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
            if asset? != nil {
                
                self.allPhotoAssets?.addObject(asset)
                /**
                BELOW SECTION OF CODE YOU CAN USE TO GET RESPECTIVE IMAGE AS UIImage OBJECT
                
                var photoURL: NSURL = asset.valueForProperty(ALAssetPropertyURLs).objectForKey("public.jpeg") as NSURL
                
                var alAssetResultBlock: ALAssetsLibraryAssetForURLResultBlock = {(asset :ALAsset!) -> Void in
                
                let assetRepresentation: ALAssetRepresentation = asset.defaultRepresentation()
                let fulImage: Unmanaged<CGImage>! = assetRepresentation.fullResolutionImage()
                if fulImage? != nil {
                var largeImage = UIImage(CGImage: fulImage.takeUnretainedValue())
                println(largeImage)
                }
                
                }
                
                var alAssetAccessFailureBlock: ALAssetsLibraryAccessFailureBlock = { (error: NSError!) -> Void in
                println("error", error.localizedDescription)
                }
                
                ImageGalleryViewController.assetLibrary().assetForURL(photoURL, resultBlock: alAssetResultBlock, failureBlock: alAssetAccessFailureBlock)
                **/
            }
        }
        
        self.makePhotoThumbnails()
    }
    
    private func makePhotoThumbnails() {
        self.scrollView?.canCancelContentTouches = true
        
        var column: Int = 0
        var row: Int = 0
        var startingY: Int = 5
        var size: CGSize = CSThumbnailDimension.thumbnailDimension()
        var offsetHeight: CGFloat = 0.0
        
        self.allPhotoAssets?.enumerateObjectsUsingBlock({ (object: AnyObject!,index: Int, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
            var asset: ALAsset = object as ALAsset
            
            if column>2 {
                ++row;
                column = 0
            }
            
            var thumbnail: CSPhotoThumbnailView = CSPhotoThumbnailView(image: UIImage(CGImage: asset.thumbnail().takeUnretainedValue()))
            thumbnail.userInteractionEnabled = true
            thumbnail.tag = row*3 + column
            
            var point: CGPoint = CGPoint()
            point.x = CGFloat(size.width/2 + size.width*CGFloat(column) + 15)
            point.y = CGFloat(CGFloat(startingY) + size.height*CGFloat(row)) + CGFloat(thumbnail.frame.size.height/2)
            thumbnail.center = point
            thumbnail.clipsToBounds = true
            ++column
            var singleTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "thumbnailDidTapped:")
            singleTapGesture.numberOfTapsRequired = 1
            singleTapGesture.numberOfTouchesRequired = 1
            thumbnail.addGestureRecognizer(singleTapGesture)
            
            self.scrollView?.addSubview(thumbnail)
            offsetHeight = thumbnail.frame.origin.y + size.height
        })
        
        self.scrollView?.contentSize = CGSizeMake(self.view.frame.size.width,(offsetHeight + CGFloat(startingY)))
        
    }
    
    func selectedImages(completionHandler: (images: NSArray) -> Void) {
        callback = completionHandler
    }
    
    func thumbnailDidTapped(gesture: UITapGestureRecognizer) {
        var thumbnail: CSPhotoThumbnailView = gesture.view as CSPhotoThumbnailView
        var tag: NSString = NSString(format:"%d", thumbnail.tag)
        var contains = selectedImages?.containsObject(tag)
        
        if contains == true {
            var checkMark = thumbnail.viewWithTag(9999)
            checkMark?.removeFromSuperview()
            selectedImages?.removeObject(tag)
            
        } else {
            var checkMark: UIImageView = UIImageView(image: UIImage(named: "checkmark"))
            checkMark.tag = 9999;
            checkMark.center = CGPointMake(thumbnail.frame.size.width-checkMark.frame.size.width/2, thumbnail.frame.size.height-checkMark.frame.size.height/2)
            thumbnail.addSubview(checkMark)
            selectedImages?.addObject(tag)
        }
        
        self.navigationItem.rightBarButtonItem?.enabled = selectedImages?.count>0
    }
    
    func cancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func selectButtonTapped(sender: AnyObject) {
        var images: NSMutableArray = NSMutableArray()
        selectedImages?.enumerateObjectsUsingBlock({ (selection: AnyObject!, index: Int, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
            var photo: ALAsset = self.allPhotoAssets?.objectAtIndex(selection.integerValue) as ALAsset
            let assetRepresentation: ALAssetRepresentation = photo.defaultRepresentation()
            let fulImage: Unmanaged<CGImage>! = assetRepresentation.fullScreenImage()
            if fulImage? != nil {
                var largeImage = UIImage(CGImage: fulImage.takeUnretainedValue())
                images.addObject(largeImage)
            }
        })
        callback!(images: images)
        self.dismissViewControllerAnimated(true, completion:nil)
    }
    
}