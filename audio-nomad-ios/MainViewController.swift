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
    
    
    // MARK: - Initializers
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Styles
    
    
    // MARK: - Methods
    
    // MARK: - Actions
    
    @IBAction func takePhoto(sender: AnyObject) {

        let imagePickerActionSheet = UIAlertController(title: "Snap/Upload Photo", message: nil, preferredStyle: .ActionSheet)

        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let cameraButton = UIAlertAction(title: "Take Photo", style: .Default) { (alert) -> Void in
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .Camera
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
            imagePickerActionSheet.addAction(cameraButton)
        }

        let libraryButton = UIAlertAction(title: "Choose Existing", style: .Default) { (alert) -> Void in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .PhotoLibrary
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        imagePickerActionSheet.addAction(libraryButton)

        let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel) { (alert) -> Void in
        
        }
        imagePickerActionSheet.addAction(cancelButton)

        presentViewController(imagePickerActionSheet, animated: true, completion: nil)
    }

}


extension MainViewController: UIImagePickerControllerDelegate {
    
}