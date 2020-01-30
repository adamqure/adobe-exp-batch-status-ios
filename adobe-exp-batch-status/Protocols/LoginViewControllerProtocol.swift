//
//  LoginViewControllerProtocol.swift
//  adobe-exp-batch-status
//
//  Created by Adam Ure on 1/30/20.
//  Copyright © 2020 Adam Ure. All rights reserved.
//

import Foundation

protocol LoginViewControllerProtocol {
    func showError(message: String)
    func loginSuccessful()
}
