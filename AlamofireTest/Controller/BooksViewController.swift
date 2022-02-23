//
//  BooksViewController.swift
//  AlamofireTest
//
//  Created by ebsadmin on 27/01/22.
//  Copyright © 2022 droisys. All rights reserved.
//

import UIKit
import Alamofire
import DropDown

class BooksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var books = [[String: Any]]()
    var filteredBooks = [[String: Any]]()
    var url = "https://rss.applemarketingtools.com/api/v2/us/books/top-free/10/books.json"
    let countryMenu = DropDown()
    let typeMenu = DropDown()
    var selectedCountry = "us"
    var selectedType = "books"
    lazy var searchbar = UISearchBar()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchbar.delegate = self
        navigationItem.titleView = searchbar
        searchbar.placeholder = "Search books"
        Alamofire.request("https://rss.applemarketingtools.com/api/v2/us/books/top-free/10/books.json").responseJSON { (response) in
            if let allData = response.result.value as? [String: Any] {
                print(allData)
                let feed = allData["feed"] as! [String: Any]
                self.books = feed["results"] as! [[String: Any]]
                self.filteredBooks = self.books
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredBooks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! TableViewCell
        cell.artistName.text = filteredBooks[indexPath.row][Constants.Keys.artistName] as? String
        cell.artistName.customLabelStyle()
        cell.artistId.text = filteredBooks[indexPath.row][Constants.Keys.artistId] as? String
        cell.releaseDate.text = filteredBooks[indexPath.row][Constants.Keys.releaseDate] as? String
        cell.profileImage.sd_setImage(with: URL(string: filteredBooks[indexPath.row][Constants.Keys.image] as! String)!, placeholderImage: UIImage(named: "Default books.png"))
        cell.profileImage.makeRounded()
        return cell
    }
}
extension BooksViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count != 0 {
            filteredBooks = books.filter({ (dict) -> Bool in
                (dict[Constants.Keys.artistName] as! String).lowercased().contains(searchText.lowercased())
            })
        }
        else {
            filteredBooks = books
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}


