//
//  LoginViewController.swift
//  audio-nomad-ios
//
//  Created by Fedor Garin on 4/16/16.
//  Copyright © 2016 thefedoration. All rights reserved.
//


import UIKit

class LoginViewController: UIViewController, UINavigationControllerDelegate {
    
    // MARK: - Variables
    
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
    
    @IBAction func onLoginButtonClicked(sender: AnyObject) {
        
        // Make authorize call to SDK to get secure access token for the user.
        // While making the first call you can specify the minimum basic
        // scopes needed.
        // Requesting both scopes for the current user.
        let requestScopes: [AnyObject] = ["profile", "postal_code"]
        let delegate: AMZNAuthorizeUserDelegate = AMZNAuthorizeUserDelegate()
        AIMobileLib.authorizeUserForScopes(requestScopes, delegate: delegate)
    }    
    
}
