//
//  UIImage.swift
//  CoffeeChat
//
//  Created by Lucy Xu on 1/31/21.
//  Copyright © 2021 cuappdev. All rights reserved.
//

import UIKit

extension UIImage {

    /// Return a resized image of targetSize
    func resize(toSize targetSize: CGSize) -> UIImage? {
        let horizontalRatio = targetSize.width / size.width
        let verticalRatio = targetSize.height / size.height
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }

    /// Return base64 string representation of image
    func toBase64() -> String? {
        guard let imageData = self.jpegData(compressionQuality: 1) else { return nil }
        return imageData.base64EncodedString()
    }
    
}
