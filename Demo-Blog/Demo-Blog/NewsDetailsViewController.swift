//
//  NewsDetailsViewController.swift
//  Demo-Blog
//
//  Created by Sam on 06/07/23.
//

import UIKit
import CCPlugin
import GoogleSignIn

class NewsDetailsViewController: UIViewController {
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var txtView: UITextView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblAuthor: UILabel!
    @IBOutlet var lblDate: UILabel!
    
    var data: Article?
    var isNeedToShowPayWall: Bool = true
    var contentID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setData()
        if isNeedToShowPayWall {
            CCplugin.shared.configure(mode: .stage, clientID: "6336e56f047afa7cb875739e")
            CCplugin.shared.debugMode = true
            CCplugin.shared.showPayWall(contentID: contentID, parentView: view, googleLogInDelegate: self, completiondelegate: self)
        }
    }
    
    fileprivate func setData() {
        let imgURL = self.data?.urlToImage
        let titleTxt = self.data?.title
        let descTxt = self.data?.description
        let authorTxt = self.data?.author
        let dateTxt = self.getConvertedDate()
        
        if let imageUrl = imgURL {
            imgView.downloadImage(from: imageUrl)
        }
        
        if let txt = titleTxt {
            lblTitle.text = txt
        }
        
        if let txt = authorTxt {
            lblAuthor.text = txt
        }
        
        if let txt = dateTxt {
            lblDate.text = txt
        }
        
        if let txt = descTxt {
            txtView.text = txt + txt + txt + txt + txt + txt + txt
        }
    }
    
    fileprivate func getConvertedDate() -> String? {
        if let inputDateString = self.data?.publishedAt {
            let inputDateFormatter = DateFormatter()
            inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "dd-MM-yyyy"
            if let inputDate = inputDateFormatter.date(from: inputDateString) {
                let outputDateString = outputDateFormatter.string(from: inputDate)
                return outputDateString
            } else {
                print("Failed to convert date")
            }
        }
        return nil
    }
}

extension NewsDetailsViewController: CCPluginCompletionHandlerDelegate {
    func success() {
        print("CCPluginCompletionHandlerDelegate:success()")
        Helper.isLoggedIn = true
        if Helper.userName?.isEmpty == true {
            CCplugin.shared.getUserDetail(contentID: "Client-Story-Id-5", completiondelegate: self)
        }
    }
    
    func failure() {
        print("CCPluginCompletionHandlerDelegate:failure()")
    }
    
    func purchasedOrNot(accessTime: Bool) {
        debugPrint("purchasedOrNot:\(accessTime)")
        if accessTime == true {
            Helper.isLoggedIn = true
            if Helper.userName?.isEmpty == true {
                CCplugin.shared.getUserDetail(contentID: "Client-Story-Id-5", completiondelegate: self)
            }
        }
    }
}

extension NewsDetailsViewController: CCPluginUserDetailsDelegate {
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

extension NewsDetailsViewController {
    fileprivate func autoLogIn(email: String?) {
        // Define the API endpoint URL
        if let apiURL = URL(string: "https://api.conscent.art/api/v1/client/generate-temp-token") {
            // Create the request object
            var request = URLRequest(url: apiURL)
            request.httpMethod = "POST"
            
            // Define the request body parameters (if any)
            var parameters: [String: Any] = [:]
            if let input = email, !input.isEmpty {
                parameters["email"] = input
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
                                    CCplugin.shared.debugMode = true
                                    DispatchQueue.main.async {
                                        if let input = email, !input.isEmpty {
                                            CCplugin.shared.autoLogIn(contentID: "Client-Story-Id-1", clientID: "6336e56f047afa7cb875739e", token: tempAuthToken, email: input, parentView: self.view, autoLogInDelegate: self)
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
}

extension NewsDetailsViewController: CCPluginAutoLogInDelegate {
    func autoLogInsuccess() {
        debugPrint("Login Successfully")
    }
    
    func autoLogInfailure() {
        Toast.shared.showToast(message: "Login Failed",alignment: .center)
    }
}


extension NewsDetailsViewController: CCPluginGoogleLogInDelegate {
    func startGoogleLogin() {
        debugPrint("startGoogleLogin")
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil else {
                Toast.shared.showToast(message: "Unable to Sign in with Google", alignment: .center)
                return
            }

          // If sign in succeeded, display the app's main content View.
            guard let signInResult = signInResult else { return }
            let user = signInResult.user

            if let emailAddress: String = user.profile?.email {
                print("emailAddress::\(String(describing: emailAddress))")
                Helper.isLoggedIn = true
                Helper.userName = emailAddress
                self.autoLogIn(email: emailAddress)
            } else {
                Toast.shared.showToast(message: "Unable to Sign in with Google", alignment: .center)
            }
        }
    }
}
