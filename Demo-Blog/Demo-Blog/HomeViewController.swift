//
//  HomeViewController.swift
//  Demo-Blog
//
//  Created by Sam on 16/06/23.
//

import UIKit

class HomeViewController: PolioPagerViewController {
    override func viewDidLoad() {
        setup()
        super.viewDidLoad()
    }
    
    private func setup() {
        // If you don't need a search tab, add the following code "before" super.viewDidLoad().
        self.needSearchTab = false
        
        // selectedBar
        selectedBarHeight = 3
        selectedBar.layer.cornerRadius = 0
        selectedBar.backgroundColor = .link
        tabBackgroundColor = .white
        
        // cells
        eachLineSpacing = 0
    }
    
    override func tabItems() -> [TabItem] {
        return [TabItem(title: "Home"),
                TabItem(title: "Entertainment"),
                TabItem(title: "Bollywood"),
                TabItem(title: "Technology")]
    }
    
    override func viewControllers() -> [UIViewController] {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController1 = storyboard.instantiateViewController(withIdentifier: "PremiumViewController")
        let viewController2 = storyboard.instantiateViewController(withIdentifier: "PremiumViewController")
        let viewController3 = storyboard.instantiateViewController(withIdentifier: "PremiumViewController")
        let viewController4 = storyboard.instantiateViewController(withIdentifier: "PremiumViewController")
        
        return [viewController1, viewController2, viewController3, viewController4]
    }
}
