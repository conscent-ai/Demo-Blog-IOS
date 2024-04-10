//
//  Helper.swift
//  Demo-Blog
//
//  Created by Sam on 09/04/24.
//

import Foundation
import UIKit

extension UIImageView {
    func downloadImage(from url: String) {
        if let imgURL = URL(string: url) {
            let urlRequest = URLRequest(url: imgURL)
            let task = URLSession.shared.dataTask(with: urlRequest)
            { (data, response, error) in
                if let responseData = data, error == nil {
                    DispatchQueue.main.async {
                        self.image = UIImage(data: responseData)
                    }
                }
            }
            task.resume()
        }
    }
}

class Helper {
    static var userName: String? {
        get {
            return UserDefaults.standard.value(forKey: "userName") as? String
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "userName")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var isLoggedIn: Bool? {
        get {
            return UserDefaults.standard.value(forKey: "isLoggedIn") as? Bool
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "isLoggedIn")
            UserDefaults.standard.synchronize()
        }
    }
}
