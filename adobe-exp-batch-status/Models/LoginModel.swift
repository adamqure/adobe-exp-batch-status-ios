//
//  LoginModel.swift
//  adobe-exp-batch-status
//
//  Created by Adam Ure on 1/30/20.
//  Copyright © 2020 Adam Ure. All rights reserved.
//

import Foundation
import SwiftyJWT
import SwiftyCrypto
import SwiftyJSON
import KeychainAccess

class LoginModel: LoginModelProtocol {
    
    let constants = Constants()
    var callback: LoginPresenterProtocol?
    var api_key = ""
    var secret = ""
    
    init(presenterCallback: LoginPresenterProtocol) {
        self.callback = presenterCallback
        if let path = Bundle.main.path(forResource: "config", ofType: "json")
        {
            if let jsonData = NSData(contentsOf: URL(fileURLWithPath: path))
            {
                let json = try! JSON(data: jsonData as Data)
                self.api_key = json["api_key"].stringValue
                self.secret = json["secret"].stringValue
            }
        }
    }

    /**
        Login will create the JWT and then send the request to Adobe to retrieve the access token
     */
    func login(clientSecret: String, clientId: String, organizationID: String, technicalAccountID: String) {
        //Call the login method
        let jwt = createJWT(imsOrg: organizationID, sub: technicalAccountID)
                
        let headers = ["Content-Type": "application/x-www-form-urlencoded"]

        let postData = NSMutableData(data: "client_id=\(self.api_key)&client_secret=\(clientSecret)&jwt_token=\(jwt)".data(using: String.Encoding.utf8)!)
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://ims-na1.adobelogin.com/ims/exchange/jwt/")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        
        authInfo.clientSecret = clientSecret
        authInfo.imsOrg = organizationID
        authInfo.sub = technicalAccountID
        authInfo.clientID = clientId
        authInfo.apiKey = self.api_key
        auth.jwt = jwt

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            if (error != nil) {
                print(error!)
                self.callback?.loginFailed()
            }
            guard let dataResponse = data else { self.callback?.loginFailed()
                return
            }
            print(String(data: dataResponse, encoding: .utf8)!)
            let httpResponse = response as? HTTPURLResponse
            if httpResponse?.statusCode == 400 {
                self.callback?.loginFailed()
                return
            }
            do {
                let dictionary = try JSONSerialization.jsonObject(with: dataResponse, options: []) as! NSDictionary
                auth.token = dictionary.value(forKey: "access_token") as! String
                auth.expiration = dictionary.value(forKey: "expires_in") as! Int
                let keychain = Keychain(service: "com.example.adobe-exp-batch-status-keychain")
                keychain["org_id"] = authInfo.imsOrg
                keychain["sub"] = authInfo.sub
                keychain["client_id"] = authInfo.clientID
                keychain["client_secret"] = authInfo.clientSecret
                keychain["access_token"] = auth.token
                keychain["expires_in"] = String(auth.expiration)
                self.callback?.loginSuccessful()
            } catch {
                self.callback?.loginFailed()
            }
            
        })

        dataTask.resume()
    }
    
    /**
        JWT token needs the exp, iss, sub, link, and aud.
     */
    func createJWT(imsOrg: String, sub: String) -> String {
        
        let privateKey = try! RSAKey.init(base64String: secret, keyType: .PRIVATE)
        let algorithm = JWTAlgorithm.rs256(privateKey)
        var payload = JWTPayload()
        let headerWithKeyId = JWTHeader.init()
        
        //Get Current Date
        let currentDate = Date()
        let expTime = currentDate.addingTimeInterval(600)
        let expInt = Int(expTime.timeIntervalSince1970)
        
        
        payload.customFields = [
            "exp": EncodableValue(value: expInt),
            "iss": EncodableValue(value: imsOrg),
            "sub": EncodableValue(value: sub),
            "https://ims-na1.adobelogin.com/s/ent_dataservices_sdk": EncodableValue(value: true),
            "aud": EncodableValue(value: "https://ims-na1.adobelogin.com/c/" + self.api_key)
            ] as [String : EncodableValue]
        
        let jwtToken = JWT.init(payload: payload, algorithm: algorithm, header: headerWithKeyId)
        
        return (jwtToken?.rawString)!
    }
}
