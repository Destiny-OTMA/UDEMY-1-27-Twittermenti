//
//  ViewController.swift
//  Twittermenti
//  Based on the original app created by Angela Yu on 07/17/2018.
//
//  Modified by Destiny Sopha starting on 09/13/2019.
//  Copyright © 2019 Over The Moon Apps. All rights reserved.
//
//  The following is a list of external articles I used for modifications made here
//
//  Using Property Lists for API Keys
//  https://dev.iachieved.it/iachievedit/using-property-lists-for-api-keys-in-swift-applications/
//
//

import UIKit
import Foundation // Required for the switch statement i guess
import SwifteriOS
import CoreML
import SwiftyJSON


class ViewController: UIViewController {
  
  @IBOutlet weak var backgroundView: UIView!
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var sentimentLabel: UILabel!
  
  let sentimentClassifier = TweetSentimentClassifier()
  
  let tweetsCount = 100 // This is how many tweets the app will retreive (maximum allowed for free is 100)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  @IBAction func predictPressed(_ sender: Any) {
     FetchTweets()
  }

  
  func FetchTweets() {
    
    let apiKeyID = valueForAPIKey(named:"Twitter_API_Key")
    let apiSecretKeyID = valueForAPIKey(named:"Twitter_API_SecretKey")
    let swifter = Swifter(consumerKey: apiKeyID, consumerSecret: apiSecretKeyID)
    
    if let searchText = textField.text {
      
      swifter.searchTweet(using: searchText, lang: "en", count: tweetsCount, tweetMode: .extended, success: { (results, metadata) in
        
        var tweets = [TweetSentimentClassifierInput]()
        
        for i in 0..<self.tweetsCount {
          if let tweet = results[i]["full_text"].string {
            let tweetForClassification = TweetSentimentClassifierInput(text: tweet)
            tweets.append(tweetForClassification)
          }
          
        }
        
        self.makePrediction(with: tweets)

      }) { (error) in
        print("There was an error with the Twitter API request, \(error)")
      }
      
    }

  }

  
  func makePrediction(with tweets: [TweetSentimentClassifierInput]) {
    
    do {
      
      let predictions = try self.sentimentClassifier.predictions(inputs: tweets)
      
      var sentimentScore = 0
      
      for pred in predictions {
        let sentiment = pred.label
        
        if sentiment == "Pos" {
          sentimentScore += 1
        } else if sentiment == "Neg" {
          sentimentScore -= 1
        }
        
      }
      
      updateUI(with: sentimentScore)
      
    } catch {
      print("There was an error with making a prediction, \(error)")
    }

  }

  
  func updateUI(with sentimentScore: Int) {
    
    switch sentimentScore {
      case 21 ... self.tweetsCount: self.sentimentLabel.text = "😍"
      case 11 ... 20: self.sentimentLabel.text = "😀"
      case 1 ... 10: self.sentimentLabel.text = "🙂"
      case 0: self.sentimentLabel.text = "😐"
      case -9 ... -1: self.sentimentLabel.text = "🙁"
      case -20 ... -10: self.sentimentLabel.text = "😡"
      default: self.sentimentLabel.text = "🤮"
    }

  }

}

