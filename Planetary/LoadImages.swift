//
//  LoadImages.swift
//  Planetary
//
//  Created by Matthew Turk on 8/20/17.
//  Copyright © 2017 MonitorMOJO, Inc. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache <AnyObject,AnyObject>()

extension UIImageView {
    
    func loadUsingCache(_ theUrl: String) {
        
        self.image = nil
        
        //check cache for image
        if let cachedImage = imageCache.object(forKey: theUrl as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        //otherwise download it
        let url = URL(string: theUrl)
        URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
            
            //print error
            if (error != nil){
                print(error!)
                return
            }
            
            DispatchQueue.main.async(execute: {
                if let downloadedImage = UIImage(data: data!){
                    imageCache.setObject(downloadedImage, forKey: theUrl as AnyObject)
                    self.image = downloadedImage
                }
            })
            
        }).resume()
    }
    
}
