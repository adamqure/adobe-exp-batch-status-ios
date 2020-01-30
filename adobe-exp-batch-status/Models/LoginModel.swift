//
//  LoginModel.swift
//  adobe-exp-batch-status
//
//  Created by Adam Ure on 1/30/20.
//  Copyright © 2020 Adam Ure. All rights reserved.
//

import Foundation

class LoginModel: LoginModelProtocol {
    
    var callback: LoginPresenterProtocol?
    
    init(presenterCallback: LoginPresenterProtocol) {
        self.callback = presenterCallback
    }

    func login(clientSecret: String, clientId: String, organizationID: String, technicalAccountID: String) {
        //Call the login method
    }
}
