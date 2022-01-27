//
//  FirstViewController.swift
//  AlamofireTest
//
//  Created by ebsadmin on 21/01/22.
//  Copyright © 2022 droisys. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var data = [["Media Type", "music","podcasts", "apps", "books"], ["Country", "in", "us", "au", "hk"], ["Type", "albums", "music-videos", "playlists", "songs"], ["Result Limit", "10","25","50"], ["Chart", "most-played"]]
    var url = "https://rss.applemarketingtools.com/api/v2/us/music/most-played/10/albums.json"
    var urlDict = ["country": "", "mediaType": "", "resultLimit": "", "chart": "", "type": ""]
    // https://rss.applemarketingtools.com/api/v2/us/music/most-played/10/albums.json // JSON example
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Dictionary(grouping: data, by: {$0.first!}).keys.sorted())
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count - 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FirstTableViewCell
        cell.textLabel!.text = data[indexPath.section][indexPath.row + 1 ]
        var key = ""
        switch indexPath.section {
        case 0:
            key = "mediaType"
        case 1:
            key = "country"
        case 2:
            key = "type"
        case 3:
            key = "resultLimit"
        case 4:
            key = "chart"
        default:
            cell.backgroundColor = UIColor.white
            
        }
        if urlDict[key] == data[indexPath.section][indexPath.row + 1 ]  { // since urlDict["key"] will only have name of selected row, so if value of urlDict["key"] is ..
            cell.backgroundColor = UIColor.red                            // equal to cell name then make it selected/red
        }
        else {
            cell.backgroundColor = UIColor.white
        }
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(data[section].first!)"
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 25
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath)
        switch indexPath.section {
        case 0:
            urlDict["mediaType"] = cell!.textLabel!.text!
            
            if cell!.textLabel!.text == "music" {
                data[2] = ["Type", "albums", "music-videos", "playlists", "songs"]
                data[4] = ["Chart", "most-played"]
            }
            else if cell!.textLabel!.text == "podcasts" {
                data[2] = ["Type", "podcast-episodes", "podcasts"]
                data[4] = ["Chart", "top"]
            }
            else if cell!.textLabel!.text == "apps" {
                data[2] = ["Type", "apps"]
                data[4] = ["Chart", "top-free", "top-paid"]
            }
            else if cell!.textLabel!.text == "books" {
                data[2] = ["Type", "books"]
                data[4] = ["Chart", "top-free", "top-paid"]
            }
        case 1:
            urlDict["country"] = cell!.textLabel!.text!
        case 2:
            urlDict["type"] = cell!.textLabel!.text!
        case 3:
            urlDict["resultLimit"] = cell!.textLabel!.text!
        case 4:
            urlDict["chart"] = cell!.textLabel!.text!
        default:
            url = "https://rss.applemarketingtools.com/api/v2/us/music/most-played/10/albums.json"
        }
        tableView.reloadData()
    }
    
    @IBAction func showList(_ sender: UIButton) {
        performSegue(withIdentifier: "toVC", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let a = segue.destination as! ViewController
        a.passedUrlDict = urlDict
        print("a.passedUrlDict = \(a.passedUrlDict)")
        print(urlDict)
    }
}
