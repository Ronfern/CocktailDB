//
//  NavBar.swift
//  CocktailDB
//
//  Created by Роман Чугай on 09.09.2020.
//  Copyright © 2020 Роман Чугай. All rights reserved.
//

import UIKit

class NavBar: UIView {
    
    override func draw(_ rect: CGRect) {
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize.init(width: 0, height: 4)
        self.layer.shadowColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.7
    }
    

    
}
