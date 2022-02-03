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
    var url = "https://rss.applemarketingtools.com/api/v2/us/books/top-free/10/books.json"
    let countryMenu = DropDown()
    let typeMenu = DropDown()
    var selectedCountry = "us"
    var selectedType = "books"
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Alamofire.request("https://rss.applemarketingtools.com/api/v2/us/books/top-free/10/books.json").responseJSON { (response) in
            if let allData = response.result.value as? [String: Any] {
                print(allData)
                let feed = allData["feed"] as! [String: Any]
                self.books = feed["results"] as! [[String: Any]]
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.artistName.text = books[indexPath.row]["artistName"] as? String
        cell.artistId.text = books[indexPath.row]["artistId"] as? String
        cell.releaseDate.text = books[indexPath.row]["releaseDate"] as? String
        cell.profileImage.sd_setImage(with: URL(string: books[indexPath.row]["artworkUrl100"] as! String)!, placeholderImage: UIImage(named: "Default books.png"))
        return cell
    }
}
