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
// import Foundation
import SwifteriOS
import CoreML

class ViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!

    let sentimentClassifier = TweetSentimentClassifier()
  
    let tweetsCount = 100 // This is how many tweets the app will retreive (maximum allowed for free is 100)
  
    override func viewDidLoad() {
        super.viewDidLoad()

      // When we start moving stuff, I thinik we should leave teh next three lines here //
      let apiKeyID = valueForAPIKey(named:"Twitter_API_Key")
      let apiSecretKeyID = valueForAPIKey(named:"Twitter_API_SecretKey")
      let swifter = Swifter(consumerKey: apiKeyID, consumerSecret: apiSecretKeyID)
      
      let prediction = try! sentimentClassifier.prediction(text: "@Apple is the best company!")
      print(prediction.label)

      swifter.searchTweet(using: "@Apple", lang: "en", count: tweetsCount, tweetMode: .extended, success: { (results, metadata) in
        // print(results) // prints the JSAON of the past 100 tweets
      }) { (error) in
        print("There was an error with the Twitter API request, \(error)")
      }
      
    }

    @IBAction func predictPressed(_ sender: Any) {
    
    }
  
  func FetchTweets() {
    
  }

}

