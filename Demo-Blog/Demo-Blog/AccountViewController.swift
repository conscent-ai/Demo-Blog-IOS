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
        CCplugin.shared.configure(mode: .sandbox, clientID: "661907c2487ae1aba956dcc4")
        CCplugin.shared.userLogIn(userLogInDelegate: self)
    }
    
    @IBAction func logout(_ sender: UIButton) {
        CCplugin.shared.userLogout(userLogOutDelegate: self)
        vwLogIn.isHidden = false
        vwLogOut.isHidden = true
        Helper.isLoggedIn = false
        Helper.userName = ""
        lblTitle.text = Helper.userName
    }
}

extension AccountViewController: CCPluginUserDetailsDelegate {
    func success(userDetails: CCPlugin.UserDetails) {
        debugPrint(userDetails)
        Toast.shared.showToast(message: "PhoneNo.: \(userDetails.phoneNumber ?? "") Email: \(userDetails.email ?? "") Name: \(userDetails.name ?? "")", alignment: .center, size: 60)
        
        if let phone = userDetails.phoneNumber, !phone.isEmpty {
            Helper.userName = userDetails.phoneNumber
        }
        
        if let email = userDetails.email, !email.isEmpty {
            Helper.userName = userDetails.email
        }
//        Helper.userName = userDetails.phoneNumber
//        Helper.userName = userDetails.email
    }
    
    func failure(error: String) {
        debugPrint(error)
    }
}

extension AccountViewController: CCPluginUserLogOutDelegate {
    func userLogOutSuccess() {
        Toast.shared.showToast(message: "You have been successfully logged out!", alignment: .center, size: 60)
    }
    
    func userLogOutFailure() {
        Toast.shared.showToast(message: "Logout Failed", alignment: .center, size: 60)
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
        
    }
}

extension AccountViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        
        btnLogin.isEnabled = true
        if btnLogin.isEnabled {
            btnLogin.backgroundColor = .link
        } else {
            btnLogin.backgroundColor = .opaqueSeparator
        }
        return true
    }
}
extension AccountViewController: CCPluginUserLogInDelegate {
    func userLogInSuccess(message: String, userId: String, authToken: String) {
        CCplugin.shared.getUserDetail(completiondelegate: self)
        debugPrint("message: \(message), userId: \(userId), authToken: \(authToken)")
                Helper.isLoggedIn = true
                self.vwContainerLogin.isHidden = true
                self.vwContainerAccount.isHidden = false
        
                self.vwLogIn.isHidden = true
                self.vwLogOut.isHidden = false
        Toast.shared.showToast(message: "Login Successfully \(userId)", alignment: .center, size: 60)
    }
    
    func userLogInFailure() {
        Toast.shared.showToast(message: "Login Failed", alignment: .center, size: 60)
    }
}

