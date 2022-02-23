//
//  AppsViewController.swift
//  AlamofireTest
//
//  Created by ebsadmin on 27/01/22.
//  Copyright © 2022 droisys. All rights reserved.
//

import UIKit
import Alamofire
import DropDown

class AppsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var filteredApps = [[String: Any]]()
    var apps = [[String: Any]]()
    var url = "https://rss.applemarketingtools.com/api/v2/us/apps/top-free/10/apps.json"
    let countryMenu = DropDown()
    let typeMenu = DropDown()
    var selectedCountry = "us"
    var selectedType = "apps"
    lazy var searchbar = UISearchBar()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchbar.delegate = self
        Alamofire.request("https://rss.applemarketingtools.com/api/v2/us/apps/top-free/10/apps.json").responseJSON { (response) in
            if let allData = response.result.value as? [String: Any] {
                print(allData)
                let feed = allData["feed"] as! [String: Any]
                self.apps = feed["results"] as! [[String: Any]]
                self.filteredApps = self.apps
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        loadAPI(apiURL: url)
        let myView = UIView(frame: navigationController?.navigationBar.frame ?? .zero)
        navigationController?.navigationBar.topItem?.titleView = myView
        guard let topView = navigationController?.navigationBar.topItem?.titleView else {
            return
        }
        countryMenu.dataSource = ["in", "us", "hk", "eg"]
        typeMenu.dataSource = ["apps"]
        countryMenu.anchorView = topView  
        typeMenu.anchorView = topView
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Country", style: .plain, target: self, action: #selector(countryTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Type", style: .plain, target: self, action: #selector(typeTapped))
        navigationItem.titleView = searchbar
    }
    @objc func countryTapped() {
        countryMenu.show()
        countryMenu.selectionAction = { index, title in
            self.selectedCountry = title
            self.url = Constants.firstUrlPart + self.selectedCountry + "/apps/top-free/10/" + self.selectedType + ".json"
            print(self.url)
            self.navigationItem.leftBarButtonItem?.title = self.selectedCountry
            self.loadAPI(apiURL: self.url)
        }
    }
    @objc func typeTapped() {
        typeMenu.show()
        typeMenu.selectionAction = { index, title in
            self.selectedType = title
            self.url = Constants.firstUrlPart + self.selectedCountry + "/apps/top-free/10/" + self.selectedType + ".json"
            print(self.url)
            self.navigationItem.rightBarButtonItem?.title = self.selectedType
            self.loadAPI(apiURL: self.url)
        }
    }

    func loadAPI(apiURL: String) {
        Alamofire.request(self.url).responseJSON { (response) in
            if let allData = response.result.value as? [String: Any] {
                print(allData)
                let feed = allData["feed"] as! [String: Any]
                self.filteredApps = feed["results"] as! [[String: Any]]
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredApps.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! TableViewCell
        cell.artistName.text = filteredApps[indexPath.row][Constants.Keys.artistName] as? String
        cell.artistName.customLabelStyle()
        cell.artistId.text = filteredApps[indexPath.row][Constants.Keys.appName] as? String
        cell.releaseDate.text = filteredApps[indexPath.row][Constants.Keys.releaseDate] as? String
        cell.profileImage.sd_setImage(with: URL(string: filteredApps[indexPath.row][Constants.Keys.image] as! String)!, placeholderImage: UIImage(named: "Default apps.png"))
        cell.profileImage.makeRounded()
        return cell
    }
}
extension AppsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count != 0 {
            filteredApps = apps.filter({($0[Constants.Keys.artistName] as! String).lowercased().contains(searchText.lowercased())})
        }
        else {
            filteredApps = apps
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

