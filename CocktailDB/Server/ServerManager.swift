//
//  ServerManager.swift
//  CocktailDB
//
//  Created by Роман Чугай on 07.09.2020.
//  Copyright © 2020 Роман Чугай. All rights reserved.
//

import Alamofire


struct Constants {
    
    static let tintColor = UIColor.init(red: 1.0, green: 78.0/255.0, blue: 32.0/255.0, alpha: 1.0)
    
    struct DOMAIN {
        static let reques = "https://www.thecocktaildb.com/api/json/v1/1/"
    }
    
    struct ROUTE {
        static let category = "list.php?c=list"
        static let drink = "filter.php?c="
    }
    
    static func allCategory() -> String {
        return DOMAIN.reques + ROUTE.category
    }
    
    static func fetchDrinks(by category: String) -> String {
        let url = DOMAIN.reques + ROUTE.drink
        return url + category.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
}


final class ServerManager {
    
    static let sharedInstance = ServerManager()
    
    func fetchAllCategory(completion: @escaping (AFDataResponse<Any>) -> Void) {
        AF.request(Constants.allCategory(),
                   method: .get,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: nil).responseJSON(completionHandler: completion)
    }
    
    func fetchDrinks(by category: String, completion: @escaping (AFDataResponse<Any>) -> Void) {
        AF.request(Constants.fetchDrinks(by: category),
                   method: .get,
                   parameters: nil,
                   encoding: JSONEncoding.default,
                   headers: nil).responseJSON(completionHandler: completion)
    }
    
}
