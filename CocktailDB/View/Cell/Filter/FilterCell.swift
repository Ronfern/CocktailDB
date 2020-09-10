//
//  FilterCell.swift
//  CocktailDB
//
//  Created by Роман Чугай on 09.09.2020.
//  Copyright © 2020 Роман Чугай. All rights reserved.
//

import UIKit

class FilterCell: UITableViewCell {

    @IBOutlet private weak var filterLabel: UILabel!
    @IBOutlet private weak var selectionImage: UIImageView!
    
    var showCheckmark: Bool = false {
         didSet {
             selectionImage.isHidden = !showCheckmark
         }
     }
    
    func customize(model: CategoryCollection?) {
        guard let category = model else { return }
        filterLabel.textColor = #colorLiteral(red: 0.4940612912, green: 0.4941501021, blue: 0.4940556288, alpha: 1)
        filterLabel.text = category.strCategory
        showCheckmark = category.selection
    }
    
}
