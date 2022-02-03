//
//  CountryViewController.swift
//  AlamofireTest
//
//  Created by ebsadmin on 27/01/22.
//  Copyright © 2022 droisys. All rights reserved.
//

import UIKit
import Alamofire
import DropDown

class PodcastViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var podcast = [[String: Any]]()
    var url = "https://rss.applemarketingtools.com/api/v2/us/podcasts/top/10/podcast-episodes.json"
    let countryMenu = DropDown()
    let typeMenu = DropDown()
    var selectedCountry = "us"
    var selectedType = "podcasts"
    
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
        typeMenu.dataSource = ["podcast-episodes", "podcasts"]
        countryMenu.anchorView = topView
        typeMenu.anchorView = topView
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Country", style: .plain, target: self, action: #selector(countryTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Type", style: .plain, target: self, action: #selector(typeTapped))

    }
    @objc func countryTapped() {
        countryMenu.show()
        countryMenu.selectionAction = { index, title in
            self.selectedCountry = title
            self.url = "https://rss.applemarketingtools.com/api/v2/" + self.selectedCountry + "/podcasts/top/10/" + self.selectedType + ".json"
            print(self.url)
            self.navigationItem.leftBarButtonItem?.title = self.selectedCountry
            self.loadAPI(apiURL: self.url)
        }
    }
    @objc func typeTapped() {
        typeMenu.show()
        typeMenu.selectionAction = { index, title in
            self.selectedType = title
            self.url = "https://rss.applemarketingtools.com/api/v2/" + self.selectedCountry + "/podcasts/top/10/" + self.selectedType + ".json"
            print(self.url)
            self.navigationItem.rightBarButtonItem?.title = self.selectedType
            self.loadAPI(apiURL: self.url)
        }
    }
    func loadAPI(apiURL: String) {
        Alamofire.request(apiURL).responseJSON { (response) in
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
        cell.profileImage.sd_setImage(with: URL(string: podcast[indexPath.row]["artworkUrl100"] as! String)!, placeholderImage: UIImage(named: "Default podcast.jpeg"))
        return cell
    }
}
