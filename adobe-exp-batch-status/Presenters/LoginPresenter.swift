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
    var loginModel: LoginModelProtocol?
    
    init(callback: LoginViewControllerProtocol) {
        self.viewCallback = callback
        self.loginModel = LoginModel(presenterCallback: self)
    }
    
    /**
        Retrieves the api-key from constants and queues the call to retrieve an auth token from Adobe
     */
    func login(clientSecret: String, clientId: String, organizationID: String, technicalAccountID: String) {
        DispatchQueue.global().async {
            self.loginModel?.login(clientSecret: clientSecret, clientId: clientId, organizationID: organizationID, technicalAccountID: technicalAccountID)
        }
    }
    
    func loginFailed() {
        DispatchQueue.main.sync(execute: {
            self.viewCallback.loginFailed()
        })
    }
    
    func loginSuccessful() {
        DispatchQueue.main.sync(execute: {
            self.viewCallback.loginSuccessful()
        })
    }
}
