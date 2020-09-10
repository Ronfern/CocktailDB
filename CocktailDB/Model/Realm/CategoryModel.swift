//
//  DrinkModel.swift
//  CocktailDB
//
//  Created by Роман Чугай on 07.09.2020.
//  Copyright © 2020 Роман Чугай. All rights reserved.
//

import RealmSwift

final class Category: Object, Decodable {
    
    var categoryCollection = List<CategoryCollection>()
    @objc dynamic var id: Int = 0
    
    enum CodingKeys: CodingKey {
        case drinks
    }
    
    override class func primaryKey() -> String? {
         return "id"
     }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        categoryCollection = try values.decodeIfPresent(List<CategoryCollection>.self, forKey: .drinks) ?? List()
        writeToRealm()
    }
    
}


final class CategoryCollection : Object, Decodable {
    
    @objc dynamic var strCategory : String?
    @objc dynamic var selection: Bool = true
    
    enum CodingKeys: CodingKey {
        
        case strCategory
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        strCategory = try values.decodeIfPresent(String.self, forKey: .strCategory)
    }
    
}

extension Category {
    
    static func all(in realm: Realm = RealmStorage.sharedInstance.uiRealm) -> List<CategoryCollection> {
        return realm.objects(Category.self).first?.categoryCollection ?? List()
    }
    
    
    func writeToRealm(in realm: Realm = RealmStorage.sharedInstance.uiRealm) {
        do {
            try realm.write {
                realm.add(self, update: .modified)
            }
        } catch let error {
            print("ERROR DELETING : \(error)")
        }
    }
}
