//
//  PremiumViewController.swift
//  Demo-Blog
//
//  Created by Sam on 16/06/23.
//

import UIKit
import CCPlugin
import GoogleSignIn

class PremiumViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    var articles: [Article]? = []
    var arrPurchasedIndex: [Int] = [Int]()
    var selectedIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchArticles()
    }
    
    func fetchArticles() {
        guard let fileURL = Bundle.main.url(forResource: "data", withExtension: "json") else {
            fatalError("data.json file not found")
        }
        
        guard let jsonData = try? Data(contentsOf: fileURL) else {
            fatalError("Failed to read data from file")
        }
        
        let decoder = JSONDecoder()
        guard let news = try? decoder.decode(NewsModel.self, from: jsonData) else {
            fatalError("Failed to decode JSON data")
        }
        
        self.articles = news.articles
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension PremiumViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleCell
        
        cell.selectionStyle = .none
        cell.title.text = self.articles?[indexPath.item].title
        cell.desc.text = self.articles?[indexPath.item].description
        
        if let imageUrl = self.articles?[indexPath.item].urlToImage {
            cell.imgView.downloadImage(from: imageUrl)
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles?.count ?? 0
    }
    
    //didSelectRow- this method is going to fire when select row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewsDetailsViewController") as! NewsDetailsViewController
        
        if indexPath.row <= 5 {
            vc.contentID = "Client-Story-Id-\(indexPath.row)"
        } else {
            vc.contentID = "Client-Story-Id-5"
        }
        
        vc.data = self.articles?[indexPath.item]
        print("self.parent::\(String(describing: self.parent))")
        if let pageVC = self.parent as? PageViewController,
           let parentVC = pageVC.parentVC as? HomeViewController,
           let nvc = parentVC.parent?.navigationController {
            vc.isNeedToShowPayWall = false
            nvc.pushViewController(vc, animated: true)
        } else {
            vc.isNeedToShowPayWall = true
            self.parent?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
