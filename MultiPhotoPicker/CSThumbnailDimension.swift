//
//  CSThumbnailDimension.swift
//  MultiPhotoPicker
//
//  Created by Sailender Singh on 03/10/14.
//  You can  use, modify, this class or can use in any
//  project but you have to use above mentioned named where
//  ever you will use this class. It is must.
//  Copyright (c) 2014 Sailender Singh. All rights reserved.
//

import Foundation
import UIKit

class CSThumbnailDimension: NSObject {
    class func thumbnailDimension() -> CGSize {
        var size: CGSize? = nil
        let width: CGFloat = CGFloat(UIScreen.mainScreen().bounds.width);
        let factor: CGFloat = CGFloat(width/320);
        size = CGSizeMake(CGFloat(98*factor), CGFloat(100*factor))
        return size!
    }
}