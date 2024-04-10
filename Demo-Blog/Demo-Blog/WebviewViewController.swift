//
//  WebviewViewController.swift
//  MNTFeed
//
//  Created by Cons Bulaqueña on 12/03/2018.
//  Copyright © 2018 consios. All rights reserved.
//

import UIKit
import WebKit

class WebviewViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    
    var url: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let strURL = url,
            let finalURL = URL(string: strURL) {
            webView.load(URLRequest(url: finalURL))
        }
    }
    
    @IBAction func close() {
        self.dismiss(animated: false)
    }
}
