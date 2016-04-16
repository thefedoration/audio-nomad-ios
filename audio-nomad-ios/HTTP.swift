//
//  HTTP.swift
//  audio-nomad-ios
//
//  Created by Naveed Jooma on 4/16/16.
//  Copyright © 2016 thefedoration. All rights reserved.
//

import Foundation
import Alamofire

enum HTTP: URLRequestConvertible {
    
    static let defaults = NSUserDefaults.standardUserDefaults()
    static let baseURLString = "\(Settings.HTTPProtocol)\(Settings.DomainURL)"
    static let OAuthTokenDefaultsKey = "HTTP.OAuthToken"
    static var OAuthToken: [String: AnyObject] {
        get {
            return defaults.objectForKey(OAuthTokenDefaultsKey) as? Dictionary<String, AnyObject> ?? [String: AnyObject]()
        } set {
            defaults.setObject(newValue, forKey: OAuthTokenDefaultsKey)
        }
    }
    
    case post(String, [String: AnyObject])
    case put(String, [String: AnyObject])
    case get(String)
    case delete(String)
    
    var method: Alamofire.Method {
        switch self {
        case .post:
            return .POST
        case .get:
            return .GET
        case .put:
            return .PUT
        case .delete:
            return .DELETE
        }
    }
    
    var path: String {
        switch self {
        case .post(let path, _):
            return "\(path)"
        case .get(let path):
            return "\(path)"
        case .put(let path, _):
            return "\(path)"
        case .delete(let path):
            return "\(path)"
        }
    }
    
    // MARK: URLRequestConvertible
    
    var URLRequest: NSMutableURLRequest {
        var urlString = path[path.startIndex] == "/" ? "\(HTTP.baseURLString)\(path)" : path
        urlString = urlString.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let URL = NSURL(string: urlString)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL)
        mutableURLRequest.HTTPMethod = method.rawValue
        
        if let token = HTTP.OAuthToken["accessToken"] as? String {
            mutableURLRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        switch self {
        case .post(_, let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        case .put(_, let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        default:
            return mutableURLRequest
        }
    }
    
    static func fullyQualifiedURLStringFromString(path: String) -> String {
        let urlString = path[path.startIndex] == "/" ? "\(HTTP.baseURLString)\(path)" : path
        return urlString
    }
    
    static func fullyQualifiedURLFromString(url: String) -> NSURL? {
        return NSURL(string: HTTP.fullyQualifiedURLStringFromString(url))
    }
    
    /**
     Handles server errors by parsing the error message and returning a success value (always false) and the error message.
     
     - parameter data: `AnyObject` of the data received from the server
     
     - returns: success `Bool` which will always be `false`
     - returns: error message `String` received from the server
     
     */
    static func handleError(data: AnyObject?) -> (Bool, String) {
        print(data)
        if let e = data as? NSDictionary {
            if let ed = e.valueForKey("error_description") as? String {
                return (false, ed)
            } else if let ed = e.valueForKey("detail") as? String {
                return (false, ed)
            }
        }
        return (false, "There was an error processing your request.")
    }
    
    // basic function to draw image from url in an async fashion
    static func drawAsyncImage(imageURL: String, imageView: UIImageView){
        var imageUrlString = imageURL
        if imageUrlString[imageUrlString.startIndex]=="/"{
            imageUrlString = Settings.HTTPProtocol + Settings.DomainURL + imageUrlString
        }
        let url = NSURL(string: imageUrlString)
        
        // Load the image data in a different thread
        let asyncQueue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
        dispatch_async(asyncQueue) {
            let data = NSData(contentsOfURL: url!)
            dispatch_async(dispatch_get_main_queue()) {
                if let imageData = data {
                    imageView.image = UIImage(data: imageData)
                }
            }
        }
    }
    
}
