//
//  Array.swift
//  CocktailDB
//
//  Created by Роман Чугай on 10.09.2020.
//  Copyright © 2020 Роман Чугай. All rights reserved.
//

import Foundation

extension Array {
    func getElement(at index: Int) -> Element? {
        let isValidIndex = index >= 0 && index < count
        return isValidIndex ? self[index] : nil
    }
}
