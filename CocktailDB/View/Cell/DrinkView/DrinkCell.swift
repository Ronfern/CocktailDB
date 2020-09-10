//
//  DrinkCell.swift
//  CocktailDB
//
//  Created by Роман Чугай on 08.09.2020.
//  Copyright © 2020 Роман Чугай. All rights reserved.
//

import UIKit
import Nuke

class DrinkCell: UITableViewCell {
    
    @IBOutlet weak var drinkImage: UIImageView!
    @IBOutlet weak var drinkTitleLabel: UILabel!
    
    func customize(model: Drink?) {
        drinkImage.image = nil
        drinkTitleLabel.text = ""
        drinkTitleLabel.textColor = #colorLiteral(red: 0.4940612912, green: 0.4941501021, blue: 0.4940556288, alpha: 1)
        
        drinkTitleLabel.text = model?.strDrink
        if let imgURlString = model?.strDrinkThumb, let urlImage = URL(string: imgURlString) {
            Nuke.loadImage(with: urlImage, into: drinkImage)
        }
    }
    
}


