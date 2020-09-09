//
//  RealmStorage.swift
//  CocktailDB
//
//  Created by Роман Чугай on 07.09.2020.
//  Copyright © 2020 Роман Чугай. All rights reserved.
//

import RealmSwift

class RealmStorage: NSObject {
  
  static let sharedInstance = RealmStorage()
  private override init() {}
  
  lazy var uiRealm: Realm = {
    let uiRealm: Realm
    do {
      uiRealm = try Realm()
    } catch {
      let nserror = error as NSError
      fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    }
    return uiRealm
  }()
  
}
