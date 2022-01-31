//
//  CountryViewController.swift
//  AlamofireTest
//
//  Created by ebsadmin on 27/01/22.
//  Copyright © 2022 droisys. All rights reserved.
//

import UIKit
import Alamofire

class PodcastViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var podcast = [[String: Any]]()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Alamofire.request("https://rss.applemarketingtools.com/api/v2/us/podcasts/top/10/podcast-episodes.json").responseJSON { (response) in
            if let allData = response.result.value as? [String: Any] {
                print(allData)
                let feed = allData["feed"] as! [String: Any]
                self.podcast = feed["results"] as! [[String: Any]]
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcast.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.artistName.text = podcast[indexPath.row]["artistName"] as? String
        cell.artistId.text = podcast[indexPath.row]["id"] as? String
        cell.releaseDate.text = podcast[indexPath.row]["name"] as? String
        URLSession.shared.dataTask(with: URL(string: podcast[indexPath.row]["artworkUrl100"] as! String)! , completionHandler: { (data, response, error) -> Void in
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
