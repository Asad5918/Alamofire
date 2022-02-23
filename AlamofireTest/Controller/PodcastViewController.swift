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

    var filteredPodcast = [[String: Any]]()
    var podcast = [[String: Any]]()
    var url = String()
    let countryMenu = DropDown()
    let typeMenu    = DropDown()
    var selectedCountry = Constants.defaultCountry
    var selectedType    = "podcasts"
    lazy var searchBar  = UISearchBar()

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        API_handler.requestAPI(url: Constants.defaultPodcastURL, completionHandler: {(results) -> Void in
            self.podcast = results as! [[String: Any]]
            self.filteredPodcast = self.podcast
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        let myView = UIView(frame: navigationController?.navigationBar.frame ?? .zero)
        navigationController?.navigationBar.topItem?.titleView = myView
        guard let topView = navigationController?.navigationBar.topItem?.titleView else {
            return
        }
        countryMenu.dataSource = [Enum.CountryMenu.India.rawValue, Enum.CountryMenu.Usa.rawValue, Enum.CountryMenu.Egypt.rawValue, Enum.CountryMenu.HongKong.rawValue]
        typeMenu.dataSource    = [Enum.TypeMenu.PodcastEpisode.rawValue, Enum.TypeMenu.Podcasts.rawValue]
        countryMenu.anchorView = topView
        typeMenu.anchorView    = topView
        navigationItem.leftBarButtonItem  = UIBarButtonItem(title: "Country", style: .plain, target: self, action: #selector(countryTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Type", style: .plain, target: self, action: #selector(typeTapped))
        navigationItem.titleView = searchBar
        searchBar.placeholder    = Constants.podcastSearchbarPlaceholder
        
    }
    @objc func countryTapped() {
        countryMenu.show()
        countryMenu.selectionAction = { index, title in
            self.selectedCountry = title
            self.url = Constants.firstUrlPart + self.selectedCountry + Constants.podcastMiddleUrlPart + self.selectedType + Constants.lastUrlPart
            print(self.url)
            self.navigationItem.leftBarButtonItem?.title = self.selectedCountry
            API_handler.requestAPI(url: self.url, completionHandler: {(results) -> Void in
                self.podcast = results as! [[String: Any]]
                self.filteredPodcast = self.podcast
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        }
    }
    @objc func typeTapped() {
        typeMenu.show()
        typeMenu.selectionAction = { index, title in
            self.selectedType = title
            self.url = Constants.firstUrlPart + self.selectedCountry + Constants.podcastMiddleUrlPart + self.selectedType + Constants.lastUrlPart
            print(self.url)
            self.navigationItem.rightBarButtonItem?.title = self.selectedType
            API_handler.requestAPI(url: self.url, completionHandler: {(results) -> Void in
                self.podcast = results as! [[String: Any]]
                self.filteredPodcast = self.podcast
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPodcast.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! TableViewCell
        cell.artistName.text  = filteredPodcast[indexPath.row][Constants.Keys.artistName] as? String
        cell.artistName.customLabelStyle()
        cell.releaseDate.text = filteredPodcast[indexPath.row][Constants.Keys.podCastName] as? String
        cell.artistId.text    = filteredPodcast[indexPath.row][Constants.Keys.podCastId] as? String
        cell.profileImage.sd_setImage(with: URL(string: filteredPodcast[indexPath.row][Constants.Keys.image] as! String)!, placeholderImage: UIImage(named: Constants.podcastImgPlaceholder))
        cell.profileImage.makeRounded()
        return cell
    }
}
extension PodcastViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count != 0 {
            filteredPodcast = podcast.filter({ (dict) -> Bool in
                (dict[Constants.Keys.artistName] as! String).lowercased().contains(searchText.lowercased())
            })
        }
        else {
            filteredPodcast = podcast
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
