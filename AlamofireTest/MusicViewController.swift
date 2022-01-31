//
//  MusicViewController.swift
//  AlamofireTest
//
//  Created by ebsadmin on 27/01/22.
//  Copyright © 2022 droisys. All rights reserved.
//

import UIKit
import Alamofire

class MusicViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var music = [[String: Any]]()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Alamofire.request("https://rss.applemarketingtools.com/api/v2/us/music/most-played/10/albums.json").responseJSON { (response) in
            if let allData = response.result.value as? [String: Any] {
                print(allData)
                let feed = allData["feed"] as! [String: Any]
                self.music = feed["results"] as! [[String: Any]]
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return music.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.artistName.text = music[indexPath.row]["artistName"] as? String
        cell.artistId.text = music[indexPath.row]["artistId"] as? String
        cell.releaseDate.text = music[indexPath.row]["releaseDate"] as? String
        URLSession.shared.dataTask(with: URL(string: music[indexPath.row]["artworkUrl100"] as! String)! , completionHandler: { (data, response, error) -> Void in
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
