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
        // Load new view controller with user identifying information
        // as the user is now successfully logged in.
        let delegate: AMZNGetProfileDelegate = AMZNGetProfileDelegate()
        AIMobileLib.getProfile(delegate)
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
    func checkIsUserSignedIn() {
        print("checking if user ir logged int")
        var delegate: AMZNGetAccessTokenDelegate = AMZNGetAccessTokenDelegate()
        var requestScopes: [AnyObject] = ["profile", "postal_code"]
        AIMobileLib.getAccessTokenForScopes(requestScopes, withOverrideParams: nil, delegate: delegate)
    }
    
    func requestDidSucceed(apiResult: APIResult) {
        print("token success")
        var delegate: AMZNGetProfileDelegate = AMZNGetProfileDelegate()
        AIMobileLib.getProfile(delegate)
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
        // Your additional logic after the user authorization state is cleared.
        UIAlertView(title: "", message: "User Logged out.", delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: "").show()
    }
    
    func requestDidFail(errorResponse: APIError) {
        print("logout fail")
        UIAlertView(title: "", message: "User Logout failed with message: \(errorResponse.error.message)", delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: "").show()
    }
}
