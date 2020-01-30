//
//  LoginPresenter.swift
//  adobe-exp-batch-status
//
//  Created by Adam Ure on 1/30/20.
//  Copyright © 2020 Adam Ure. All rights reserved.
//

import Foundation

class LoginPresenter: LoginPresenterProtocol {
    var viewCallback: LoginViewControllerProtocol
    
    init(callback: LoginViewControllerProtocol) {
        self.viewCallback = callback
    }
    
    /**
        Retrieves the api-key from constants and queues the call to retrieve an auth token from Adobe
     */
    func login(clientSecret: String, clientId: String, organizationID: String, technicalAccountID: String) throws {
        
        //Error handling on the
        if (clientId.isEmpty) {
            throw Constants.LoginDataError.invalidClientID
        }
        if (clientSecret.isEmpty) {
            throw Constants.LoginDataError.invalidClientSecret
        }
        if (organizationID.isEmpty) {
            throw Constants.LoginDataError.invalidOrganizationID
        }
        if (technicalAccountID.isEmpty) {
            throw Constants.LoginDataError.invalidTechnicalAccountID
        }
    }
}
