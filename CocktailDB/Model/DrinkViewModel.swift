//
//  CocktailViewModel.swift
//  CocktailDB
//
//  Created by Роман Чугай on 07.09.2020.
//  Copyright © 2020 Роман Чугай. All rights reserved.
//
import RealmSwift

protocol DrinkViewModelProtocol: class {
    func drinksFetched(success: Bool, drinkCount: Int)
}

class DrinkViewModel {
    private unowned var delegate: DrinkViewModelProtocol?
    private var categories = Category.all()
    private var drinks: [[Drink]] = []

    init(delegate: DrinkViewModelProtocol) {
        self.delegate = delegate
        self.fetchAll()
    }
    
    func numberOfSections() -> Int {
        return drinks.count
    }
    
    func numberOfRows(section: Int) -> Int {
        return drinks[section].count
    }

    func getCategory(at index: Int) -> String? {
        guard index < Category.all().count else {
            return nil
        }
        return Category.all()[index].strCategory
    }
    
    func getDrink(in section: Int, at index: Int) -> Drink? {
        guard index < drinks[section].count else {
            return nil
        }
        return drinks[section][index]
    }

    func fetchAll() {
        ServerManager.sharedInstance.fetchAllCategory { (result) in
            switch result.response?.statusCode {
            case 200?:
                if  let data = result.data,
                    let responseModel = try? JSONDecoder().decode(Category.self, from: data) {
                    self.categories = responseModel.categoryCollection
                }
            default:
                self.categories = List()
            }
        }
    }
    
    
    func fetchDrinks(offset: Int, limit: Int, shouldAppend: Bool) {
        let page = drinks.count
        let work = DispatchWorkItem {
            ServerManager.sharedInstance.fetchDrinks(by: self.getCategory(at: page) ?? "") { (result) in
                switch result.response?.statusCode {
                case 200?:
                    if  let data = result.data,
                        let drinksResponseModel = try? JSONDecoder().decode(Drinks.self, from: data) {
                        if shouldAppend == false {
                            self.drinks.removeAll()
                        }
                        self.drinks.append(drinksResponseModel.drinks)
                        self.delegate?.drinksFetched(success: true, drinkCount: drinksResponseModel.drinks.count)
                    } else {
                        self.delegate?.drinksFetched(success: false, drinkCount: 0)
                    }
                default:
                    self.delegate?.drinksFetched(success: false, drinkCount: 0)
                }
            }
        }
        if drinks.count == 0 {
            self.fetchAll()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: work)
        } else {
            DispatchQueue.main.async(execute: work)
        }
    }
}




