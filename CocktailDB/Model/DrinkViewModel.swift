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
    func refreshWithFilters()
}

class DrinkViewModel {
    private weak var delegate: DrinkViewModelProtocol?
    private var categories = Category.all()
    private var drinks: [[Drink]] = []
    
    init(delegate: DrinkViewModelProtocol) {
        self.delegate = delegate
        self.fetchAll()
    }
    
    func refresh() {
        self.drinks.removeAll()
        delegate?.refreshWithFilters()
    }
    func numberOfSections() -> Int {
        return drinks.count
    }
    
    func numberOfRows(section: Int) -> Int {
        return drinks.getElement(at: section)?.count ?? 0
    }
    
    func countCategory() -> Int {
        return Category.all().count
    }
    
    func getCategoryModelBySelection(at index: Int) -> CategoryCollection? {
        
        guard index < categories.filter("selection = true").count else {
            return nil
        }
        
        return categories.filter("selection = true")[index]
    }
    
    func getCategoryModel(at index: Int) -> CategoryCollection? {
  
        return categories[index]
    }
    
    func getDrink(in section: Int, at index: Int) -> Drink? {
        return drinks.getElement(at: section)?.getElement(at: index)
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
            guard let category = self.getCategoryModelBySelection(at: page)?.strCategory  else {
                self.delegate?.drinksFetched(success: false, drinkCount: 0)
                return
            }
            ServerManager.sharedInstance.fetchDrinks(by: category) { (result) in
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: work)
        } else {
            DispatchQueue.main.async(execute: work)
        }
    }
}




