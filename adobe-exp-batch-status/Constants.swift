//
//  Constants.swift
//  adobe-exp-batch-status
//
//  Created by Adam Ure on 1/30/20.
//  Copyright © 2020 Adam Ure. All rights reserved.
//

import Foundation

struct Constants {
    let api_key: String = "d8b65ca75ee44b8ca9bf87b6fdc0a174"
    let jwt_url: String = "https://ims-na1.adobelogin.com/s/ent_dataservices_sdk"
    let aud: String = "https://ims-na1.adobelogin.com/c/"
    
    enum LoginDataError: Error {
        case invalidClientID
        case invalidClientSecret
        case invalidOrganizationID
        case invalidTechnicalAccountID
    }
}
