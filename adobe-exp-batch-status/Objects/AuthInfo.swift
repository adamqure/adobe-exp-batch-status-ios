//
//  AuthInfo.swift
//  adobe-exp-batch-status
//
//  Created by Adam Ure on 1/30/20.
//  Copyright © 2020 Adam Ure. All rights reserved.
//

import Foundation

/**
    The AuthInfo Class manages the data necessary to login to the Adobe Experience Platform
 */
var authInfo = AuthInfo(apiKey: "", clientSecret: "", imsOrg: "", sub: "", clientID: "")
class AuthInfo {
    //The API Key is the key associated with our development account
    //This key should be retrieved from some config file
    var apiKey: String
    
    //The Client Secret is the client's secret retrieved from Adobe.
    //The user inputs this secret on login
    var clientSecret: String
    
    //The IMS Org is the IMS Organization ID retrieved from Adobe
    //The user inputs this id on login
    var imsOrg: String
    
    //The sub is the Technical Account ID retrieved from Adobe
    //The user inputs this id on login
    var sub: String
    
    //The Client ID is the id retrieved from Adobe
    //The user inputs this id on login
    var clientID: String
    
    init(apiKey: String, clientSecret: String, imsOrg: String, sub: String, clientID: String) {
        self.apiKey = apiKey
        self.clientSecret = clientSecret
        self.imsOrg = imsOrg
        self.sub = sub
        self.clientID = clientID
    }
}
