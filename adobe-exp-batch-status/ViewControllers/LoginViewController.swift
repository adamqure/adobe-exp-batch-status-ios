//
//  LoginViewController.swift
//  adobe-exp-batch-status
//
//  Created by Adam Ure on 1/30/20.
//  Copyright © 2020 Adam Ure. All rights reserved.
//

import UIKit

/**
 ViewController for the Login functionality of the app
 The user can open the adobe website in safari to access the necessary information
 The user will be able to put in fields for authentication of the app and then login, which will signal for us to retrieve an access token
 */
class LoginViewController: UIViewController {

    //Link up the UI components
    @IBOutlet weak var clientIdTextField: UITextField!
    @IBOutlet weak var clientSecretTextField: UITextField!
    @IBOutlet weak var organizationIDTextField: UITextField!
    @IBOutlet weak var technicalAccountIDTextField: UITextField!
    
    var mPresenter: LoginPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.mPresenter = LoginPresenter(callback: self)
    }
    
    /**
        Signal the app to begin the login process, including retrieving the api key from the json file and sending the official request to the Adobe API to retrieve an access token
     */
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        do {
            //Retrieve and check the necessary information
            guard let clientID = clientIdTextField.text else {
                throw Constants.LoginDataError.invalidClientID
            }
            guard let clientSecret = clientSecretTextField.text else {
                throw Constants.LoginDataError.invalidClientSecret
            }
            guard let orgID = organizationIDTextField.text else {
                throw Constants.LoginDataError.invalidOrganizationID
            }
            guard let accountId = technicalAccountIDTextField.text else {
                throw Constants.LoginDataError.invalidTechnicalAccountID
            }
            
            if (clientID.isEmpty) {
                throw Constants.LoginDataError.invalidClientID
            }
            if (clientSecret.isEmpty) {
                throw Constants.LoginDataError.invalidClientSecret
            }
            if (orgID.isEmpty) {
                throw Constants.LoginDataError.invalidOrganizationID
            }
            if (accountId.isEmpty) {
                throw Constants.LoginDataError.invalidTechnicalAccountID
            }
            
            //Send the data logic to the presenter
            if (mPresenter != nil) {
                mPresenter?.login(clientSecret: clientSecret, clientId: clientID, organizationID: orgID, technicalAccountID: accountId)
            }
            
        } catch Constants.LoginDataError.invalidClientID {
            self.showError(message: "Invalid Client ID")
        } catch Constants.LoginDataError.invalidClientSecret{
            self.showError(message: "Invalid Client Secret")
        } catch Constants.LoginDataError.invalidOrganizationID{
            self.showError(message: "Invalid Organization ID")
        } catch Constants.LoginDataError.invalidTechnicalAccountID{
            self.showError(message: "Invalid Technical Account ID")
        } catch {
            self.showError(message: "An Error Occured")
        }
        
    }
    
    /**
        Signal the app to open Safari to the Adobe URL to retrieve account information
     */
    @IBAction func adobeWebsiteButtonPressed(_ sender: UIButton) {
        //Open the adobe url in safari
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LoginViewController: LoginViewControllerProtocol {
  
    /**
        Triggers the segue to the dataset controller
     */
    func loginSuccessful() {
        
    }
    
    /**
        Stops the loading indicator and shows the user a failed message
     */
    func loginFailed() {
          <#code#>
    }
    
    /**
        Displays an error message to the user
     */
    func showError(message: String) {
        
    }
}
