//
//  AccountViewController.swift
//  Demo-Blog
//
//  Created by Sam on 21/06/23.
//

import UIKit
import CCPlugin

class AccountViewController: UIViewController {
    @IBOutlet weak var vwContainerAccount: UIView!
    @IBOutlet weak var vwLogIn: UIView!
    @IBOutlet weak var vwLogOut: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var vwContainerLogin: UIView!
    @IBOutlet weak var tfEmailPhoneNumber: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tfEmailPhoneNumber.layer.borderColor = UIColor.darkGray.cgColor
        self.vwContainerLogin.isHidden = true
        self.vwContainerAccount.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lblTitle.text = Helper.userName
        if Helper.isLoggedIn ?? false {
            self.vwLogIn.isHidden = true
            self.vwLogOut.isHidden = false
        } else {
            self.vwLogIn.isHidden = false
            self.vwLogOut.isHidden = true
        }
    }
    
    @IBAction func login(_ sender: UIButton) {
        self.tfEmailPhoneNumber.text = ""
        self.btnLogin.isEnabled = false
        self.btnLogin.backgroundColor = .opaqueSeparator
        self.vwContainerLogin.isHidden = false
        self.vwContainerAccount.isHidden = true
    }
    
    @IBAction func logout(_ sender: UIButton) {
        CCplugin.shared.getlogout(logoutBtnDelegate: self)
        vwLogIn.isHidden = false
        vwLogOut.isHidden = true
        Helper.isLoggedIn = false
        Helper.userName = ""
        lblTitle.text = Helper.userName
    }
}

extension AccountViewController: CCPluginUserDetailsDelegate {
    func success(userDetails: String) {
        debugPrint(userDetails)
        if let jsonData = userDetails.data(using: .utf8) {
            do {
                if let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                    // Use the `json` object
                    if let phoneNumber = json["phoneNumber"] as? String {
                        Helper.userName = phoneNumber
                    } else if let email = json["email"] as? String {
                        Helper.userName = email
                    }
                }
            } catch {
                print("Error converting data to JSON: \(error)")
            }
        }
    }
    
    func failure(error: String) {
        debugPrint(error)
    }
}

extension AccountViewController: CCPluginlogout {
    func succes(successData: String) {
        debugPrint(successData)
    }
    
    func fail(error: String) {
        debugPrint(error)
    }
}

extension AccountViewController {
    @IBAction func loginButtonTapped(_ sender: Any) {
        self.resignFirstResponder()
        self.validateData()
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.resignFirstResponder()
        self.vwContainerLogin.isHidden = true
        self.vwContainerAccount.isHidden = false
    }
    
    fileprivate func validateData() {
        if isValidEmailPhoneNumber(param: tfEmailPhoneNumber.text ?? "") {
            autoLogIn(emailMobile: tfEmailPhoneNumber.text)
        } else {
            Toast.shared.showToast(message: "Enter valid email or phone number",alignment: .center)
        }
    }
    
    fileprivate func autoLogIn(emailMobile: String?) {
        // Define the API endpoint URL
        if let apiURL = URL(string: "https://api.conscent.art/api/v1/client/generate-temp-token") {
            // Create the request object
            var request = URLRequest(url: apiURL)
            request.httpMethod = "POST"
            
            // Define the request body parameters (if any)
            var parameters: [String: Any] = [:]
            if let input = emailMobile, !input.isEmpty {
                if input.contains("@") {
                    parameters["email"] = input
                } else {
                    parameters["phoneNumber"] = input
                }
            }

            do {
                let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
                request.httpBody = jsonData
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                print("Error creating JSON data: \(error)")
                return
            }
            
            // Set the Basic Authentication header
                let username = "J1EFAQR-H0N4921-QCXKVNH-6W9ZYY9"
                let password = "CFR472795Q42TTQJFV84M37A5G4SJ1EFAQRH0N4921QCXKVNH6W9ZYY9"
                if let data = "\(username):\(password)".data(using: .utf8) {
                    let base64Credentials = data.base64EncodedString()
                    let authString = "Basic \(base64Credentials)"
                    request.addValue(authString, forHTTPHeaderField: "Authorization")
                }

            // Create a URLSession instance
            let session = URLSession.shared

            // Create the data task
            let task = session.dataTask(with: request)
            { (data, response, error) in
                // Check for any errors
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                
                // Ensure there is a valid HTTP response
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Invalid response")
                    return
                }
                
                // Check the response status code
                if httpResponse.statusCode == 201 {
                    // Successful request
                    if let responseData = data {
                        // Process the response data
                        let responseString = String(data: responseData, encoding: .utf8)
                        print("Response: \(responseString ?? "")")
                        do {
                            if let json = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as? [String: AnyObject] {
                                if let tempAuthToken = json["tempAuthToken"] as? String {
                                    CCplugin.shared.configure(mode: .stage, clientID: "6336e56f047afa7cb875739e")
                                    CCplugin.shared.debugMode = true
                                    DispatchQueue.main.async {
                                        if let input = emailMobile, !input.isEmpty {
                                            if input.contains("@") {
                                                CCplugin.shared.autoLogIn(contentID: "Client-Story-Id-1", clientID: "6336e56f047afa7cb875739e", token: tempAuthToken, email: input, parentView: self.view, autoLogInDelegate: self)
                                            } else {
                                                CCplugin.shared.autoLogIn(contentID: "Client-Story-Id-1", clientID: "6336e56f047afa7cb875739e", token: tempAuthToken, phone: input, parentView: self.view, autoLogInDelegate: self)
                                            }
                                        }
                                    }
                                }
                            }
                        } catch let error {
                            print(error)
                        }
                    }
                } else {
                    // Request failed
                    print("Request failed: \(httpResponse.statusCode)")
                }
            }

            // Start the data task
            task.resume()
        }
    }
    
    func isValidEmailPhoneNumber(param: String) -> Bool {
        let emailPhoneNumberRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}|^[6-9]\\d{9}$"
        let emailPhoneNumberPredicate = NSPredicate(format: "SELF MATCHES %@", emailPhoneNumberRegex)
        return emailPhoneNumberPredicate.evaluate(with: param)
    }
}

extension AccountViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        
        btnLogin.isEnabled = isValidEmailPhoneNumber(param: newString)
        if btnLogin.isEnabled {
            btnLogin.backgroundColor = .link
        } else {
            btnLogin.backgroundColor = .opaqueSeparator
        }
        return true
    }
}

extension AccountViewController: CCPluginAutoLogInDelegate {
    func autoLogInsuccess() {
        debugPrint("Login Successfully")
        Helper.isLoggedIn = true
        Helper.userName = self.tfEmailPhoneNumber.text ?? ""
        self.lblTitle.text = Helper.userName
       
        self.vwContainerLogin.isHidden = true
        self.vwContainerAccount.isHidden = false
       
        self.vwLogIn.isHidden = true
        self.vwLogOut.isHidden = false
    }
    
    func autoLogInfailure() {
        self.vwContainerLogin.isHidden = true
        self.vwContainerAccount.isHidden = false
        Toast.shared.showToast(message: "Login Failed",alignment: .center)
    }
}


