//
//  AmazonDelegates.swift
//  audio-nomad-ios
//
//  Created by Fedor Garin on 4/16/16.
//  Copyright © 2016 thefedoration. All rights reserved.
//


// MARK: - Amazon Delegates
class AMZNAuthorizeUserDelegate: NSObject, AIAuthenticationDelegate {
    func requestDidSucceed(apiResult: APIResult!) {
        print("succeed")
        
        let delegate = AppDelegate.getAppDelegate()
        delegate.transitionToMainViewController()
        
        //let delegate: AMZNGetProfileDelegate = AMZNGetProfileDelegate()
        AIMobileLib.getProfile(AMZNGetProfileDelegate())
    }
    
    func requestDidFail(errorResponse: APIError) {
        print("fail")
        print(errorResponse.error.code)
        print(errorResponse)
        print(errorResponse.error)
        print(errorResponse.error.message)
        let message: String = errorResponse.error.message
        // Your code when the authorization fails.
        UIAlertView(title: "", message: "User authorization failed with message: \(errorResponse.error.message)", delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: "").show()
    }
    
}


class AMZNGetProfileDelegate: NSObject, AIAuthenticationDelegate {
    func requestDidSucceed(apiResult: APIResult) {
        print("got profile")
        // Get profile request succeeded. Unpack the profile information
        // and pass it to the parent view controller
        let name: String = ((apiResult.result as! [NSObject : AnyObject])["name"] as! String)
        let email: String = ((apiResult.result as! [NSObject : AnyObject])["email"] as! String)
        let user_id: String = ((apiResult.result as! [NSObject : AnyObject])["user_id"] as! String)
        let postal_code: String = ((apiResult.result as! [NSObject : AnyObject])["postal_code"] as! String)
        // Pass data to view controller
        print(name)
        print(email)
        print(user_id)
        print(postal_code)
    }
    
    func requestDidFail(errorResponse: APIError) {
        print("fail profile")
        if errorResponse.error.code == kAIApplicationNotAuthorized {
            // Show authorize user button.
            print("go back to login")
            //parentViewController.showLogInPage()
        }
        else {
            // Handle other errors
            UIAlertView(title: "", message: "Error occured with message: \(errorResponse.error.message)", delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: "").show()
        }
    }
}

class AMZNGetAccessTokenDelegate: NSObject, AIAuthenticationDelegate {

    func requestDidSucceed(apiResult: APIResult) {
        
        let delegate = AppDelegate.getAppDelegate()
        delegate.transitionToMainViewController()
//        print("token success")
//        var delegate: AMZNGetProfileDelegate = AMZNGetProfileDelegate()
//        AIMobileLib.getProfile(delegate)
    }
    
    func requestDidFail(errorResponse: APIError) {
        print("token fail")

        if errorResponse.error.code == kAIApplicationNotAuthorized {
            // Show Login with Amazon button.
            print("show login with amazon button")
        }
        else {
            // Handle other errors
            UIAlertView(title: "", message: "Error occurred with message: \(errorResponse.error.message)", delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: "").show()
        }
    }
}


class AMZNLogoutDelegate: NSObject, AIAuthenticationDelegate {
    func requestDidSucceed(apiResult: APIResult) {
        print("no success")
        // go to login screen
        let delegate = AppDelegate.getAppDelegate()
        delegate.transitionToLoginViewController()
    }
    
    func requestDidFail(errorResponse: APIError) {
        print("logout fail")
        UIAlertView(title: "", message: "User Logout failed with message: \(errorResponse.error.message)", delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: "").show()
    }
}
