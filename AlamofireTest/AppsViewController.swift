//
//  AppsViewController.swift
//  AlamofireTest
//
//  Created by ebsadmin on 27/01/22.
//  Copyright © 2022 droisys. All rights reserved.
//

import UIKit
import Alamofire

class AppsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var apps = [[String: Any]]()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Alamofire.request("https://rss.applemarketingtools.com/api/v2/us/apps/top-free/10/apps.json").responseJSON { (response) in
            if let allData = response.result.value as? [String: Any] {
                print(allData)
                let feed = allData["feed"] as! [String: Any]
                self.apps = feed["results"] as! [[String: Any]]
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apps.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.artistName.text = apps[indexPath.row]["artistName"] as? String
        cell.artistId.text = apps[indexPath.row]["name"] as? String
        cell.releaseDate.text = apps[indexPath.row]["releaseDate"] as? String
        URLSession.shared.dataTask(with: URL(string: apps[indexPath.row]["artworkUrl100"] as! String)! , completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                cell.profileImage.image = UIImage(data: data!)
            })
        }).resume()
        return cell
    }
}

