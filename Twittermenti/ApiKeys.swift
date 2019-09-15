//
//  ApiKeys.swift
//  Twittermenti
//
//  Created by Destiny Sopha on 9/15/2019.
//  Copyright © 2019 Over The Moon Apps. All rights reserved.
//

import Foundation

func valueForAPIKey(named keyname:String) -> String {
  // Credit to the original source for this technique at
  // http://blog.lazerwalker.com/blog/2014/05/14/handling-private-api-keys-in-open-source-ios-apps
  let filePath = Bundle.main.path(forResource: "ApiKeys", ofType: "plist")
  let plist = NSDictionary(contentsOfFile:filePath!)
  let value = plist?.object(forKey: keyname) as! String
  return value
}
