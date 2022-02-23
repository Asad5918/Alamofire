//
//  API_handler.swift
//  AlamofireTest
//
//  Created by ebsadmin on 04/02/22.
//  Copyright © 2022 droisys. All rights reserved.
//

import Foundation
import Alamofire

class API_handler {
class func requestAPI(url: String, completionHandler: @escaping (Any?) -> Void) {
    var results = [[String: Any]]()
    Alamofire.request(url).responseJSON { (response) in
        if let allData = response.result.value as? [String: Any] {
            print("alldata = \(allData)")
            let feed = allData["feed"] as! [String: Any]
            results = feed["results"] as! [[String: Any]]
            completionHandler(results)
            }
        }
    }
}
