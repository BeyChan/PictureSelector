//
//  MYImage+Addition.swift
//  图片选择器
//
//  Created by Melody Chan on 16/7/7.
//  Copyright © 2016年 canlife. All rights reserved.
//

import UIKit

extension UIImage{
    /**
     根据传入的宽度压缩成成比例不变的图片
     
     - parameter width: 指定宽度
     */
    func imageWithScale(width:CGFloat) -> UIImage
    {
        //1.根据宽度计算高度
        let height = width * size.height / size.width
        
        //2.根据比例绘制新的图片
        let currentSize = CGSize(width: width, height: height)
        UIGraphicsBeginImageContext(currentSize)
        drawInRect(CGRect(origin: CGPointZero, size: currentSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}