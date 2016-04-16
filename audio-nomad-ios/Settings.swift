//
//  Settings.swift
//  audio-nomad-ios
//
//  Created by Fedor Garin on 4/15/16.
//  Copyright © 2016 thefedoration. All rights reserved.
//

import UIKit

struct Settings {
    
    private static let PRODUCTION_MODE = true
    
    // MARK: - HTTP Settings
    static var HTTPProtocol: String {
        get {
            if PRODUCTION_MODE {
                return "http://"
            } else {
                return "http://"
            }
        }
    }
    static var DomainURL: String {
        get {
            if PRODUCTION_MODE {
                return "52.91.217.58"
            } else {
                return "localhost:8000"
            }
        }
    }
    static var OAuthClientId: String {
        get {
            if PRODUCTION_MODE {
                return "Q2vDOSUDHMQUCMuLYOBqS6eUuQLNfOr0P96KST8N"
            } else {
                return "Sk2qJ12vloi6A9SZDMhHdl4UXgD4ZxohSNndC9p0"
            }
        }
    }
    static var OAuthClientSecret: String {
        get {
            if PRODUCTION_MODE {
                return "FHr3Vz6CdoBJGVLhxjetRdmTHDz810NhHHsveK62na9pBbffCyUqMHjS9oL0HcV3hVnwQ2bUhst8iuG6r388zwYSfLlXbxbpGhsM5NWMgJJ7avUcxLRjsN3s3xPQdwc8"
            } else {
                return "Zo4YjKt5O4EwbdCYPpLUtqMZSgTfnyDnrwKkIoIC7hrbyxuC5qGQiZvFtl18M1ioC4IKpLBiiMTJRFSqTv6xWyjuflAbD5g53RKLQltGIlpMAQYeEIcc9ROCdwltZ131"
            }
        }
    }
    
    // MARK: - Screen Dimensions
    static let screenWidth: CGFloat = UIScreen.mainScreen().bounds.width
    static let screenHeight: CGFloat = UIScreen.mainScreen().bounds.height
    
    // MARK: - Colors
    static let BackgroundColor = UIColor(red: 44/255, green: 62/255, blue:80/255, alpha: 1)
    static let LightBackgroundColor = UIColor(red: 52/255, green: 73/255, blue:94/255, alpha: 1)
    static let PrimaryAccentColor = UIColor(red: 52/255, green: 152/255, blue:219/255, alpha: 1)
    static let SecondaryAccentColor = UIColor(red: 46/255, green: 204/255, blue:113/255, alpha: 1)
    static let PrimaryTextColor = UIColor(red: 236/255, green: 240/255, blue:241/255, alpha: 1)
    static let SecondaryTextColor = UIColor(red: 189/255, green: 195/255, blue:199/255, alpha: 1)
    static let LightShadowColor = UIColor(red: 255/255, green: 255/255, blue:255/255, alpha: 0.2)
}