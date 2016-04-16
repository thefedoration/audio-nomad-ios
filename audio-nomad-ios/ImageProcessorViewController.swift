//
//  ImageProcessorViewController.swift
//  audio-nomad-ios
//
//  Created by Fedor Garin on 4/15/16.
//  Copyright © 2016 thefedoration. All rights reserved.
//

import UIKit
import Alamofire

class ImageProcessorViewController: UIViewController, UINavigationControllerDelegate {

    // MARK: - Variables
    var sliderValue = 50
    var processingTime = 60.0
    private var ASIN = "B005FRGT44"
    
    // MARK: - Outlets
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageIconView: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var uploadContainerView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var processButton: UIButton!
    @IBOutlet weak var reUploadButton: UIButton!
    @IBOutlet weak var processContainerView: UIView!
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var rightSliderImage: UIImageView!
    @IBOutlet weak var leftSliderImage: UIImageView!
    
    
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
        self.imageView.clipsToBounds = true
        self.imageContainerView.clipsToBounds = true
        imageView.layer.cornerRadius = 2
        imageContainerView.layer.cornerRadius = 2
        
        // icons for image
        self.imageIconView.image = UIImage.imageWithIonicon(Ionicons.ios_camera_outline, height: self.imageIconView.frame.height, color: Settings.LightShadowColor)

        self.rightSliderImage.image = UIImage.fontAwesomeIconWithName(FontAwesome.Bullseye, textColor: Settings.PrimaryTextColor, size: CGSize(width: 30, height: 30))
        self.leftSliderImage.image = UIImage.fontAwesomeIconWithName(FontAwesome.Bolt, textColor: Settings.PrimaryTextColor, size: CGSize(width: 30, height: 30))
        
        // show/hide right components
        self.uploadContainerView.hidden = false
        self.processContainerView.hidden = true
        
        // color components
        for button in [uploadButton, reUploadButton, processButton]{
            button.backgroundColor = Settings.PrimaryAccentColor
            button.tintColor = Settings.PrimaryTextColor
            button.layer.cornerRadius = 2
            button.clipsToBounds = true
        }
        self.processButton.backgroundColor = Settings.SecondaryAccentColor
        self.imageContainerView.backgroundColor = Settings.LightBackgroundColor
        self.infoLabel.textColor = Settings.PrimaryTextColor
        
    }
    
    // MARK: - Methods
    
    // scales the image so that we can read it
    func scaleImage(image: UIImage, maxDimension: CGFloat) -> UIImage {
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
        var scaleFactor: CGFloat
        
        if image.size.width > image.size.height {
            scaleFactor = image.size.height / image.size.width
            scaledSize.width = maxDimension
            scaledSize.height = scaledSize.width * scaleFactor
        } else {
            scaleFactor = image.size.width / image.size.height
            scaledSize.height = maxDimension
            scaledSize.width = scaledSize.height * scaleFactor
        }
        
        UIGraphicsBeginImageContext(scaledSize)
        image.drawInRect(CGRectMake(0, 0, scaledSize.width, scaledSize.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    // actually does the processing, from user settings
    func performImageRecognition(image: UIImage) {
        print(NSDate())
        let tesseract = G8Tesseract()
        tesseract.language = "eng"
        tesseract.maximumRecognitionTime = 60.0
        
        // set the accuracy and speed based off of the slider
        if self.sliderValue >= 75{
            tesseract.engineMode = .TesseractCubeCombined
        } else if self.sliderValue > 50{
            tesseract.engineMode = .CubeOnly
        }  else {
            tesseract.engineMode = .TesseractOnly
            self.processingTime = (60.0 * Double(self.sliderValue + 1) / 50)
            tesseract.maximumRecognitionTime = self.processingTime
        }
        tesseract.pageSegmentationMode = .Auto
        tesseract.image = image.g8_blackAndWhite()
        tesseract.recognize()
        print(NSDate())
        self.handleReadText(tesseract.recognizedText)
    }
    
    // handles errors from reading text and also cleans it up
    func handleReadText(text:String?) {
        if text == nil || text == ""{
            let alert = UIAlertController(title: "Uh oh", message: "I couldn't find any text in that image. Are you sure you took a picture of a book?", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: .Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        if (text!.rangeOfString("error in") != nil){
            let alert = UIAlertController(title: "Uh oh", message: "I can't process that image. Please try again.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        // clean up text
        let textArray = text!.componentsSeparatedByString("\n")
        var output = [[String]]()
        for textLine in textArray{
            if textLine != "" && textLine != " "{
                var lineWords = textLine.componentsSeparatedByString(" ")
                if lineWords.count > 1{
                    lineWords.removeLast()
                    output.append(lineWords)
                }
            }
        }
        
        let url = "http://52.91.217.58/nomad/text-to-book/"
        Alamofire.request(HTTP.post(url, ["text": output]))
        .validate()
        .responseJSON { response in
            if response.result.isSuccess {
                if let data = response.result.value as? [String: AnyObject] {
                    self.ASIN = data["ASIN"] as! String
                    self.performSegueWithIdentifier("BookDetailSegue", sender: self)
                }
            } else {
                print("LKSDJFLKSJDFLKSJLDKF")
            }
        }
        print(output)
        
        return
    }
    
    private func transitionToDetails(ASIN: String) {
        
    }
    
    

    // MARK: - Actions
    
    // handles uploading of photo, either from camera or from memory
    func uploadPhoto(){
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
    
    @IBAction func pressUploadButton(sender: AnyObject) {
        self.uploadPhoto()
    }
    
    @IBAction func pressReuploadButtonButton(sender: AnyObject) {
        self.uploadPhoto()
    }
    
    @IBAction func pressProcessButton(sender: AnyObject) {
        // scale it for best readability
        let scaledImage = scaleImage(self.imageView.image!, maxDimension: 640)
        self.performImageRecognition(scaledImage)
        
        return
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        self.sliderValue = Int(sender.value)
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "BookDetailSegue":
                let dvc = segue.destinationViewController as! BookDetailViewController
                dvc.ASIN = self.ASIN
            default:
                assertionFailure("Prepare for segue fell through")
            }
        }
    }

}

extension ImageProcessorViewController: UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        // grab the image data from the picker
        let selectedPhoto = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // set to the imageview
        self.imageView.image = selectedPhoto
        
        // change the views that the user sees
        self.uploadContainerView.hidden = true
        self.processContainerView.hidden = false
        
        return self.dismissViewControllerAnimated(true, completion: nil)
    }
}
