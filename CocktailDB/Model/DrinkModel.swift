//
//  DrinkModel.swift
//  CocktailDB
//
//  Created by Роман Чугай on 08.09.2020.
//  Copyright © 2020 Роман Чугай. All rights reserved.
//

import Foundation

class Drinks: Decodable {
    
    let drinks : [Drink]
    
    enum CodingKeys: String, CodingKey {
        
        case drinks = "drinks"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        drinks = try values.decodeIfPresent([Drink].self, forKey: .drinks) ?? []
    }
}
    

class Drink : Decodable {
    let strDrink : String?
    let strDrinkThumb : String?
    let idDrink : String?

    enum CodingKeys: String, CodingKey {

        case strDrink = "strDrink"
        case strDrinkThumb = "strDrinkThumb"
        case idDrink = "idDrink"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
            self.strDrink = try values.decodeIfPresent(String.self, forKey: .strDrink)
            self.strDrinkThumb = try values.decodeIfPresent(String.self, forKey: .strDrinkThumb)
            self.idDrink = try values.decodeIfPresent(String.self, forKey: .idDrink)
    }

}
