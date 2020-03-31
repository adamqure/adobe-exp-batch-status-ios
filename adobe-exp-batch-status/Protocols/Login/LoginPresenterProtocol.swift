//
//  LoginProtocols.swift
//  adobe-exp-batch-status
//
//  Created by Adam Ure on 1/30/20.
//  Copyright © 2020 Adam Ure. All rights reserved.
//

import Foundation

protocol LoginPresenterProtocol {
    func login(clientSecret: String, clientId: String, organizationID: String, technicalAccountID: String)
    func loginFailed()
    func loginSuccessful()
}
