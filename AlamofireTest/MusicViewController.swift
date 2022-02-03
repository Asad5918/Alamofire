//
//  MusicViewController.swift
//  AlamofireTest
//
//  Created by ebsadmin on 27/01/22.
//  Copyright © 2022 droisys. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import DropDown

class MusicViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var music = [[String: Any]]()
    var url = "https://rss.applemarketingtools.com/api/v2/us/music/most-played/25/albums.json"
    let countryMenu = DropDown()
    let typeMenu = DropDown()
    var selectedCountry = "us"
    var selectedType = "albums"
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAPI(apiURL: url)
        let myView = UIView(frame: navigationController?.navigationBar.frame ?? .zero)
        navigationController?.navigationBar.topItem?.titleView = myView
        guard let topView = navigationController?.navigationBar.topItem?.titleView else {
            return
        }
        countryMenu.dataSource = ["in", "us", "hk", "eg"]
        typeMenu.dataSource = ["albums", "music-videos", "playlists", "songs"]
        countryMenu.anchorView = topView
        typeMenu.anchorView = topView
//        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapTopItem))
//        gesture.numberOfTapsRequired = 1
//        gesture.numberOfTouchesRequired = 1
//        topView.addGestureRecognizer(gesture)
//        @objc func didTapTopItem() {
//            countryMenu.show()
//        }
//        countryMenu.selectionAction = { index, title  in
//            print("Index = \(index), title = \(title) ")
//        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Country", style: .plain, target: self, action: #selector(countryTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Type", style: .plain, target: self, action: #selector(typeTapped))
    }

    @objc func countryTapped() {
        countryMenu.show()
        countryMenu.selectionAction = { index, title in
            self.selectedCountry = title
            self.url = "https://rss.applemarketingtools.com/api/v2/" + self.selectedCountry + "/music/most-played/10/" + self.selectedType + ".json"
            self.navigationItem.leftBarButtonItem?.title = self.selectedCountry
            self.loadAPI(apiURL: self.url)
        }
    }
    @objc func typeTapped() {
        typeMenu.show()
        typeMenu.selectionAction = { index, title in
            self.selectedType = title
            self.url = "https://rss.applemarketingtools.com/api/v2/" + self.selectedCountry + "/music/most-played/25/" + self.selectedType + ".json"
            self.navigationItem.rightBarButtonItem?.title = self.selectedType
            self.loadAPI(apiURL: self.url)
        }
    }
    func loadAPI(apiURL: String) {
        Alamofire.request(apiURL).responseJSON { (response) in
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
        cell.profileImage.sd_setImage(with: URL(string: music[indexPath.row]["artworkUrl100"] as! String)!, placeholderImage: UIImage(named: "Default music.png"))
        return cell
    }
    
}
