//
//  CSViewController.swift
//  MultiPhotoPicker
//
//  Created by Sailender Singh on 20/09/14.
//  You can  use, modify, this class or can use in any
//  project but you have to use above mentioned named where
//  ever you will use this class. It is must.
//  Copyright (c) 2014 Sailender Singh. All rights reserved.
//

import UIKit

class CSViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func openPhotoLibraryTapped(sender: UIButton) {
        
        let imageGalleryVC : CSImageGalleryViewController  = self.storyboard?.instantiateViewControllerWithIdentifier("ImageGalleryView") as CSImageGalleryViewController;
        let navController : UINavigationController = UINavigationController(rootViewController: imageGalleryVC);
        self.navigationController?.presentViewController(navController, animated: true, completion: nil);
        imageGalleryVC.selectedImages { (images) -> Void in
            println(images)
        }
    }
    
}

