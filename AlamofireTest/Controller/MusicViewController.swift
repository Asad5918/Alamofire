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
    var filteredMusic = [[String: Any]]()
    var url = String()
    let countryMenu = DropDown()
    let typeMenu = DropDown()
    var selectedCountry = Constants.defaultCountry
    var selectedType = "albums"
    lazy var searchbar = UISearchBar()
    let apiHandler = API_handler()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchbar.delegate = self
        API_handler.requestAPI(url: Constants.defaultMusicURL, completionHandler: { (results) in
            self.music = results as! [[String: Any]]
            self.filteredMusic = self.music
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
        typeMenu.dataSource    = [Enum.TypeMenu.Albums.rawValue, Enum.TypeMenu.MusicVideos.rawValue, Enum.TypeMenu.Playlist.rawValue, Enum.TypeMenu.Songs.rawValue]
        countryMenu.anchorView = topView
        typeMenu.anchorView    = topView
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Country", style: .plain, target: self, action: #selector(countryTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Type", style: .plain, target: self, action: #selector(typeTapped))
        navigationItem.titleView = searchbar
        searchbar.placeholder = Constants.musicSearchbarPlaceholder
    }

    @objc func countryTapped() {
        countryMenu.show()
        countryMenu.selectionAction = { index, title in
            self.selectedCountry = title
            self.url = Constants.firstUrlPart + self.selectedCountry + Constants.musicMiddleUrlPart + self.selectedType + Constants.lastUrlPart
            self.navigationItem.leftBarButtonItem?.title = self.selectedCountry
            API_handler.requestAPI(url: self.url, completionHandler: { (updatedResults) in
                self.music = updatedResults as! [[String: Any]]
                self.filteredMusic = self.music
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
            self.url = Constants.firstUrlPart + self.selectedCountry + Constants.musicMiddleUrlPart + self.selectedType + Constants.lastUrlPart
            self.navigationItem.rightBarButtonItem?.title = self.selectedType
            API_handler.requestAPI(url: self.url, completionHandler: { (updatedResults) in
                self.music = updatedResults as! [[String: Any]]
                self.filteredMusic = self.music
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMusic.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! TableViewCell
        cell.artistName.text = filteredMusic[indexPath.row][Constants.Keys.artistName] as? String
        cell.artistName.customLabelStyle()
        cell.artistId.text = filteredMusic[indexPath.row][Constants.Keys.artistId] as? String
        cell.releaseDate.text = filteredMusic[indexPath.row][Constants.Keys.releaseDate] as? String
        cell.profileImage.sd_setImage(with: URL(string: filteredMusic[indexPath.row][Constants.Keys.image] as! String)!, placeholderImage: UIImage(named: Constants.musicImgPlaceholder))
        cell.profileImage.makeRounded()
        return cell
    }
    
}
extension MusicViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count != 0 {
            filteredMusic = music.filter({($0[Constants.Keys.artistName] as! String).lowercased().contains(searchText.lowercased())})
        }
        else {
            filteredMusic = music
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
