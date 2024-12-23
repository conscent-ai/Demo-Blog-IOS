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
    var contentID: String = "Client-Story-Id-1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CCplugin.shared.getUserDetail(completiondelegate: self)
        self.setData()
        if isNeedToShowPayWall {
            CCplugin.shared.configure(mode: .sandbox, clientID: "661907c2487ae1aba956dcc4")
            CCplugin.shared.debugMode = true
            CCplugin.shared.showPayWall(contentID: contentID, title: contentID,
                                        categories: ["category1","category2","category3"] ,
                                        sections: ["section12","section14"],
                                        tags: ["premium"],
                                        contentUrl: "https://www.google.com/",
                                        authorName: "abc",
                                        parentView: view,
                                        navigationController: self.navigationController,
                                        eventParamsDelegate: self,
                                        googleUserLogInDelegate: self,
                                        completiondelegate: self,
                                        subscriberDelegate: self,
                                        signInDelegate: self)
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
    func success(accessType: String) {
        Toast.shared.showToast(message: "accessType: \(accessType)", alignment: .center, size: 60)
    }
    
    func loginSuccess(message: String, userId: String, authToken: String) {
        Toast.shared.showToast(message: "message: \(message), userId: \(userId)", alignment: .center, size: 60)
    }
    
    func onCustomLinkSlot(link: String?, contentId: String) {
        debugPrint("\(String(describing: link))")
    }
    
    func onPaywallVisible(paywallType: String, paywallDisplayType: String, paywallHeight: CGFloat) {
        debugPrint("SecondDetailViewController: paywallHeight = \(paywallHeight)")
    }
    
    func failure() {
        print("CCPluginCompletionHandlerDelegate:failure()")
    }
    
    func purchasedOrNot(accessTime: Bool) {
        debugPrint("purchasedOrNot:\(accessTime)")
        if accessTime == true {
            Helper.isLoggedIn = true
            if Helper.userName?.isEmpty == true {
                CCplugin.shared.getUserDetail(completiondelegate: self)
            }
        }
    }
}

extension NewsDetailsViewController: CCPluginUserDetailsDelegate {
    //Success failure delegate callback methods
    func success(userDetails: UserDetails) {
        debugPrint(userDetails)
        if let phone = userDetails.phoneNumber, !phone.isEmpty {
            Helper.userName = userDetails.phoneNumber
        }
        
        if let email = userDetails.email, !email.isEmpty {
            Helper.userName = userDetails.email
        }
    }
    
    func failure(error: String) {
        debugPrint(error)
    }
}

extension NewsDetailsViewController: CCPluginEventParamsDelegate {
    func success(paywallId: String, contentId: String, paywallType: String, clientId: String, anonId: String) {
        debugPrint("CCPluginEventParamsDelegate \(paywallId) \(contentId) \(paywallType) \(clientId) \(anonId)")
    }
}

extension NewsDetailsViewController: CCPluginSignBtnTapDelegate {
    func signInTap() {
//        showToast(controller: self, message: "SignInBtnTap", seconds: 0.5)
        debugPrint("SignInTap")
    }
}

extension NewsDetailsViewController: CCPluginSubscribeBtnTapDelegate {
    //subscription and signin delegate callback methods
    func subscribeBtnTap() {
//        showToast(controller: self, message: "SubscriptionBtnTap", seconds: 0.5)
        debugPrint("SubscribeBtnTap")
    }
}

extension NewsDetailsViewController: CCPluginGoogleUserLogInDelegate {
    func startGoogleLogin() {
        debugPrint("SecondDetailViewController: startGoogleLogin")
    }
    
    func googleUserLogInSuccess() {
        debugPrint("SecondDetailViewController: googleUserLogInSuccess")
    }
    
    func googleUserLogInFailure() {
        debugPrint("SecondDetailViewController: googleUserLogInFailure")
    }
    
    
}
