//
//  AuthToken.swift
//  adobe-exp-batch-status
//
//  Created by Adam Ure on 1/30/20.
//  Copyright © 2020 Adam Ure. All rights reserved.
//

import Foundation

/**
 The AuthToken Class holds the access token for this user, which is retrieved from an API call
 POST https://ims-na1.adobelogin.com/ims/exchange/jwt/

 */
var auth = AuthToken(token: "", expiration: 0, jwt: "")
class AuthToken {
    //The token is the bearer token used to authorize a user session
    var token: String
    
    //The expiration is the expiration date of the token above in string format
    var expiration: Int
    
    var jwt: String
    
    init(token: String, expiration: Int, jwt: String) {
        self.token = token
        self.expiration = expiration
        self.jwt = jwt
    }
}
