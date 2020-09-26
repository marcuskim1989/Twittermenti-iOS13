//
//  ViewController.swift
//  Twittermenti
//
//  Created by Angela Yu on 17/07/2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import SwifteriOS
import CoreML
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    let sentimentClassifier = TweetSentimentClassifier()
    
    let tweetCount = 100
    
    var swifter: Swifter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ignoreThis = IgnoreThis()
        
        swifter = Swifter(consumerKey: ignoreThis.apiKey, consumerSecret: ignoreThis.secretApiKey)
        
    }
    
    @IBAction func predictPressed(_ sender: Any) {
        
        if let searchText = textField.text {
            
            
            swifter?.searchTweet(using: searchText, lang: "en", count: tweetCount, tweetMode: .extended,success: { (results, metadata) in
                
                var tweets = [TweetSentimentClassifierInput]()
                
                for i in 0..<self.tweetCount {
                    
                    if let tweet = results[i]["full_text"].string {
                        let tweetForClassification = TweetSentimentClassifierInput(text: tweet)
                        tweets.append(tweetForClassification)
                    }
                }
                
                do {
                    let predictions = try self.sentimentClassifier.predictions(inputs: tweets)
                    
                    var sentimentScore = 0
                    
                    for prediction in predictions {
                        let sentiment = prediction.label
                        
                        if sentiment == "Pos" {
                            sentimentScore += 1
                        } else if sentiment == "Neg" {
                            sentimentScore -= 1
                        }
                    }
                    
                    print(sentimentScore)
                    
                    if sentimentScore > 20 {
                        self.sentimentLabel.text = "😍"
                    } else if sentimentScore > 10 {
                        self.sentimentLabel.text = "😄"
                    } else if sentimentScore > 0 {
                        self.sentimentLabel.text = "🙂"
                    } else if sentimentScore == 0 {
                        self.sentimentLabel.text = "😐"
                    } else if sentimentScore > -10 {
                        self.sentimentLabel.text = "😕"
                    } else if sentimentScore > -20 {
                        self.sentimentLabel.text = "😡"
                    } else {
                        self.sentimentLabel.text = "🤮"
                    }
                    
                } catch {
                    print("There was an error with making predictions: \(error)")
                }
                
            }, failure: { (error) in
                print("There was an error with the Twitter API request: \(error)")
            })
        }
    }
    
}

