//
//  MainViewController.swift
//  audio-nomad-ios
//
//  Created by Fedor Garin on 4/15/16.
//  Copyright © 2016 thefedoration. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UINavigationControllerDelegate {
    
    // MARK: - Variables
    var delegate = AMZNAuthorizeUserDelegate()
    
    // MARK: - Initializers
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.styleScreen()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Styles
    func styleScreen(){
        
        self.view.backgroundColor = Settings.BackgroundColor
        self.navigationController?.navigationBar.barTintColor = Settings.LightBackgroundColor
        self.navigationController?.navigationBar.tintColor = Settings.SecondaryTextColor
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: Settings.PrimaryTextColor,
        ]
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont.systemFontOfSize(13.0)], forState: UIControlState.Normal)

    }
    
    // MARK: - Methods

    
    // MARK: - Actions
    
    @IBAction func goToUploadPhotoScreen(sender: AnyObject) {
        performSegueWithIdentifier("goToUploadPhotoScreen", sender: nil)
    }
    
    
    @IBAction func onLoginButtonClicked(sender: AnyObject) {
        
        // Requesting both scopes for the current user.
        var requestScopes: [AnyObject] = ["profile", "postal_code"]
        var delegate: AMZNAuthorizeUserDelegate = AMZNAuthorizeUserDelegate()
        AIMobileLib.authorizeUserForScopes(requestScopes, delegate: delegate)
        
    }

}


class AMZNAuthorizeUserDelegate: NSObject, AIAuthenticationDelegate {

    func requestDidSucceed(apiResult: APIResult!) {
        print("succeed")
    }
    
    func requestDidFail(errorResponse: APIError!) {
        print("fail")
    }
    
}



