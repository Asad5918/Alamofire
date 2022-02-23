//
//  UIImageViewExtension.swift
//  AlamofireTest
//
//  Created by ebsadmin on 22/02/22.
//  Copyright © 2022 droisys. All rights reserved.
//

import UIKit
import Foundation
extension UIImageView {
    
    func makeRounded() {
        
        self.layer.borderWidth   = 1
        self.layer.masksToBounds = true
        self.layer.borderColor   = UIColor.black.cgColor
        self.layer.cornerRadius  = self.frame.height / 2
        self.clipsToBounds       = true
    }
}
