//
//  FirstViewController.swift
//  AlamofireTest
//
//  Created by ebsadmin on 21/01/22.
//  Copyright © 2022 droisys. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var data = [["Media Type", "music","podacasts", "apps", "books"], ["Country", "in", "us", "au", "hk"], ["Music Type", "albums", "music-videos", "playlists", "songs"], ["Result Limit", "10","25","50"]]
    var url = "https://rss.applemarketingtools.com/api/v2/us/music/most-played/10/albums.json"
    var country = "us"
    var mediaType = "music"
    var resultLimit = "25"
    var musicType = "albums"
    // https://rss.applemarketingtools.com/api/v2/us/music/most-played/10/albums.json // JSON example
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsMultipleSelection = true
        let arr = [[2, 1], [2, 2], [2, 3]]
        for a in arr {
            print(a)
        }
        print(Dictionary(grouping: data, by: {($0).first!}))
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("numberOfRowsInSection \(section)")
        return data[section].count - 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
//        print("numberOfSections")
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print("cellForRowAt")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FirstTableViewCell
        cell.textLabel!.text = data[indexPath.section][indexPath.row + 1 ]
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        print("titleForHeaderInSection \(section)")
        return "\(data[section].first!)"
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 25
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        cell?.isSelected = true
        switch indexPath.section {
        case 0:
            mediaType = cell!.textLabel!.text!
        case 1:
            country = cell!.textLabel!.text!
        case 2:
            musicType = cell!.textLabel!.text!
        case 3:
            resultLimit = cell!.textLabel!.text!
        default:
            url = "https://rss.applemarketingtools.com/api/v2/us/music/most-played/10/albums.json"
        }
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {

        if let selectedIndexPaths = tableView.indexPathsForSelectedRows {
            print("selectedIndexPaths = \(selectedIndexPaths)")
            for selectedIndexPath in selectedIndexPaths {
                print("selectedIndexPath = \(selectedIndexPath)")
                if selectedIndexPath.section == indexPath.section {
                    tableView.deselectRow(at: selectedIndexPath, animated: true)
                    tableView.cellForRow(at: selectedIndexPath)?.accessoryType = .none
                }
            }
        }
        return indexPath
    }

    @IBAction func showList(_ sender: UIButton) {
        performSegue(withIdentifier: "toVC", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        url = "https://rss.applemarketingtools.com/api/v2/" + country + "/" + mediaType + "/most-played/" + resultLimit + "/" + musicType + ".json"
        let a = segue.destination as! ViewController
        a.completeURL = url
        print("a.complete = \(a.completeURL)")
        print(url)
    }
}
