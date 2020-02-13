//
//  Constants.swift
//  adobe-exp-batch-status
//
//  Created by Adam Ure on 1/30/20.
//  Copyright © 2020 Adam Ure. All rights reserved.
//

import Foundation

struct Constants {
    let jwt_url: String = "https://ims-na1.adobelogin.com/s/ent_dataservices_sdk"
    let aud: String = "https://ims-na1.adobelogin.com/c/"
    let adobeURL: String = "https://console.adobe.io/integrations"
    let metascope = "https://ims-na1.adobelogin.com/s/ent_dataservices_sdk"
    
    enum LoginDataError: Error {
        case invalidClientID
        case invalidClientSecret
        case invalidOrganizationID
        case invalidTechnicalAccountID
    }
}
