//
//  UIImage+ResizeImage.swift
//  UpTech
//
//  Created by A.Zinkov on 7/14/19.
//  Copyright © 2019 ArtemZinkov. All rights reserved.
//

import UIKit

extension UIImage {
    func resizeImage(targetSize: CGSize) -> UIImage {

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let ratioToMultiply = min(widthRatio, heightRatio)
        
        let newSize = CGSize(width: size.width * ratioToMultiply,
                             height: size.height * ratioToMultiply)
        let rect = CGRect(origin: .zero, size: newSize)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
