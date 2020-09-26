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
    
    var swifter: Swifter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ignoreThis = IgnoreThis()
        
        //        let prediction = try! sentimentClassifier.prediction(text: "@Apple is the best company")
        //
        //        print(prediction.label)
        
        swifter = Swifter(consumerKey: ignoreThis.apiKey, consumerSecret: ignoreThis.secretApiKey)
        
        swifter?.searchTweet(using: "@Apple", lang: "en", count: 100, tweetMode: .extended,success: { (results, metadata) in
            
            var tweets = [TweetSentimentClassifierInput]()
            
            for i in 0..<100 {
                
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
                
            } catch {
                print("There was an error with making predictions: \(error)")
            }
            
        }, failure: { (error) in
            print("There was an error with the Twitter API request: \(error)")
        })
        
    }
    
    @IBAction func predictPressed(_ sender: Any) {
        
        
    }
    
}

