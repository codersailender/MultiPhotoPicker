//
//  CSPhotoThumbnailView.swift
//  MultiPhotoPicker
//
//  Created by Sailender Singh on 20/09/14.
//  Copyright (c) 2014 Sailender Singh. All rights reserved.
//

import Foundation
import UIKit

class CSPhotoThumbnailView: UIImageView {
    
    override init(image: UIImage!) {
        let size: CGSize = CSThumbnailDimension.thumbnailDimension()
        super.init(frame: CGRectMake(0, 0, size.width, size.height))
        self.image = UIImage(named: "thumbnailBG")
        var actualImage: UIImageView = UIImageView(frame: CGRectMake(0, 0, size.width-15, size.height-15))
        actualImage.image = image;
        actualImage.center = CGPointMake(size.width/2, size.width/2 - 3);
        self.addSubview(actualImage);
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}