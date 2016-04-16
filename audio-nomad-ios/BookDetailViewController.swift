//
//  BookDetailViewController.swift
//  audio-nomad-ios
//
//  Created by Naveed Jooma on 4/16/16.
//  Copyright © 2016 thefedoration. All rights reserved.
//

import UIKit
import Alamofire

class BookDetailViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var narratorLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    
    // MARK: - Variables
    var ASIN = "B00KTEH7WQ"
    var user = User.user_id
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        styleScreen()
        loadBookData()
        loadPersonalBookData()
    }
    
    private func styleScreen(){
        self.view.backgroundColor = Settings.BackgroundColor
        self.titleLabel.textColor = Settings.PrimaryTextColor
        self.authorLabel.textColor = Settings.PrimaryTextColor
        self.narratorLabel.textColor = Settings.PrimaryTextColor
//        self.titleLabel.textColor = Settings.PrimaryTextColor
    }
    
    private func loadBookData() {
        let url = "https://api.audible.com/1.0/catalog/products/\(ASIN)?response_groups=contributors,product_desc,media,sample,rating"
        Alamofire.request(HTTP.get(url))
        .validate()
        .responseJSON { response in
            if response.result.isSuccess {
                if let bookData = response.result.value as? [String: AnyObject] {
                    if let product = bookData["product"] as? [String: AnyObject] {
                        if let title = product["title"] as? String {
                            self.titleLabel.text = title
                        }
                        if let authors = product["authors"] as? [[String: String]] {
                            var ars = [String]()
                            for author in authors {
                                ars.append(author["name"]!)
                            }
                            let arss = ars.joinWithSeparator(", ")
                            self.authorLabel.text = "by \(arss)"
                        }
                        if let narrators = product["narrators"] as? [[String: String]] {
                            var nrs = [String]()
                            for narrator in narrators {
                                nrs.append(narrator["name"]!)
                            }
                            let nrss = nrs.joinWithSeparator(", ")
                            self.narratorLabel.text = "Narrated by \(nrss)"
                        }
                        if let pi = product["product_images"] as? [String: String] {
                            UIImage.imageFromURLString(pi["500"]!) { image in
                                self.coverImageView.image = image
                            }
                        }

                    }
                }
            }
        }
    }

    private func loadPersonalBookData() {
        let url = "https://api.audible.com/1.0/content/\(ASIN)/metadata"
        Alamofire.request(HTTP.get(url))
        .validate()
        .responseJSON { response in
            print(response.result.isSuccess)
        }
    }
    
}
