//
//  Extensions.swift
//  audio-nomad-ios
//
//  Created by Naveed Jooma on 4/16/16.
//  Copyright © 2016 thefedoration. All rights reserved.
//


// MARK: - UIImage
extension UIImage {
    /**
     Loads an image asynchronously from a given URL string
     
     - parameter url: `String` of the URL
     - parameter callback: A closure that acceps a UIImage and returns void
     */
    class func imageFromURLString(urlString: String, callback: (UIImage)->()) {
        let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
        dispatch_async(dispatch_get_global_queue(qos, 0), {
            var imageURL = urlString
            if urlString[urlString.startIndex]=="/"{
                imageURL = Settings.HTTPProtocol + Settings.DomainURL + urlString
            }
            if let url = NSURL(string: imageURL) {
                let imageData = NSData(contentsOfURL: url)
                if let data = imageData {
                    dispatch_async(dispatch_get_main_queue(), {
                        if let image = UIImage(data: data) {
                            callback(image)
                        }
                    })
                }
            }
        })
    }
}