//
//  UIImage+FromUrlString.swift
//  FilterTwitterApp
//
//  Copyright (c) 2021 Keach.T
//

import UIKit


extension UIImage {
    
    // URLから画像を取得するメソッド
    public convenience init(url: String) {
        
        let url = URL(string: url)
        
        do {
            let data = try Data(contentsOf: url!)
            self.init(data: data)!
            return
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
        
        self.init()
    }
    
    // 画像をリサイズするメソッド
    func resize(size: CGSize) -> UIImage {
        
        let widthRatio = size.width / self.size.width
        let heightRatio = size.height / self.size.height
        let ratio = (widthRatio < heightRatio) ? widthRatio : heightRatio
        let resizedSize = CGSize(width: (self.size.width * ratio), height: (self.size.height * ratio))
        
        // 画質を落とさないように以下を修正
        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 0.0)
        draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage!
    }
}
