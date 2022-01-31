//
//  ViewController.swift
//  AlamofireTest
//
//  Created by ebsadmin on 20/01/22.
//  Copyright © 2022 droisys. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDataSource {

    var results = [[String: Any]]()
    var passedUrlDict = ["country": "", "mediaType": "", "resultLimit": "", "chart": "", "type": ""]
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(passedUrlDict)
        let completeURL = "https://rss.applemarketingtools.com/api/v2/" + passedUrlDict["country"]! + "/" + passedUrlDict["mediaType"]! + "/" + passedUrlDict["chart"]! + "/" + passedUrlDict["resultLimit"]! + "/" + passedUrlDict["type"]! + ".json"
        Alamofire.request("https://rss.applemarketingtools.com/api/v2/us/music/most-played/10/albums.json").responseJSON { (response) in
            print("CompleteURL = \(completeURL)")
            if let allData = response.result.value as? [String: Any] {
                print(allData)
                let feed = allData["feed"] as! [String: Any]
                self.results = feed["results"] as! [[String: Any]]
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.artistName.text = results[indexPath.row]["artistName"] as? String
        cell.artistId.text = results[indexPath.row]["artistId"] as? String
        cell.releaseDate.text = results[indexPath.row]["releaseDate"] as? String
//        print(results[indexPath.row]["artworkUrl100"] as! String)
//        Alamofire.request(results[indexPath.row]["artworkUrl100"] as! String).responseJSON { (response) in // Should not be responseJSON
//            print("response = \(response)")
//            if let image = response.result.value {
//                print(response)
//                cell.profileImage.image = image as? UIImage
//            }
//        }
        
        
        URLSession.shared.dataTask(with: URL(string: results[indexPath.row]["artworkUrl100"] as! String)! , completionHandler: { (data, response, error) -> Void in
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
}

