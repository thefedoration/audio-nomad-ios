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
    
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    // MARK: - Initializers
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.styleScreen()
        
        if let name = User.name {
            self.infoLabel.text = "Welcome \(name)! Press the button below to upload a picture of your book."
        } else {
            self.infoLabel.text = "Welcome! Press the button below to upload a picture of your book."
        }
        
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

        for button in [actionButton]{
            button.backgroundColor = Settings.PrimaryAccentColor
            button.tintColor = Settings.PrimaryTextColor
            button.layer.cornerRadius = 2
            button.clipsToBounds = true
        }
    }
    
    // MARK: - Methods

    
    // MARK: - Actions
    
    @IBAction func goToUploadPhotoScreen(sender: AnyObject) {
        performSegueWithIdentifier("goToUploadPhotoScreen", sender: nil)
    }
    
    @IBAction func logoutButtonClicked(sender: AnyObject) {
        var delegate: AMZNLogoutDelegate = AMZNLogoutDelegate()
        AIMobileLib.clearAuthorizationState(delegate)
    }
    

}


