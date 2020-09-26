//
//  ViewController.swift
//  Twittermenti
//
//  Created by Angela Yu on 17/07/2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import SwifteriOS

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!

    var swifter: Swifter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ignoreThis = IgnoreThis()
        
        swifter = Swifter(consumerKey: ignoreThis.apiKey, consumerSecret: ignoreThis.secretApiKey)
        
        swifter?.searchTweet(using: "@Apple", lang: "en", count: 100, tweetMode: .extended,success: { (results, metadata) in
            print(results)
        }, failure: { (error) in
            print("There was an error with the Twitter API request: \(error)")
        })
        
    }

    @IBAction func predictPressed(_ sender: Any) {
    
    
    }
    
}

