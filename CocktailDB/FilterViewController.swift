//
//  FilterViewController.swift
//  CocktailDB
//
//  Created by Роман Чугай on 09.09.2020.
//  Copyright © 2020 Роман Чугай. All rights reserved.
//

import UIKit
import RealmSwift

class FilterViewController: UIViewController {
    
    @IBOutlet private weak var filterTableView: UITableView!{
        didSet {
            filterTableView.delegate = self
            filterTableView.dataSource = self
            filterTableView.register(UINib(nibName: String(describing: FilterCell.self), bundle: nil), forCellReuseIdentifier: String(describing: FilterCell.self))
        }
    }
    weak var viewModel: DrinkViewModel?
    var selectedItem: [CategoryCollection] = []
    
    @IBAction private func applyButtonTapped(_ sender: Any) {
        do {
            try  RealmStorage.sharedInstance.uiRealm.write {
                for model in selectedItem {
                    model.selection = !model.selection
                }
            }
        } catch let error {
            print("ERROR : \(error)")
        }
        viewModel?.refresh()
        if let navigator = navigationController {
            navigator.popViewController(animated: true)
        }
    }
    
    @IBAction private func backButtonTapped(_ sender: Any) {
        if let navigator = navigationController {
            navigator.popViewController(animated: true)
        }
    }
    
}

extension FilterViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.countCategory() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FilterCell.self)) as? FilterCell {
            cell.selectionStyle = .none
            if let model = viewModel?.getCategoryModel(at: indexPath.row) {
                cell.customize(model: model)
                if selectedItem.contains(where: {$0.strCategory == model.strCategory}) {
                    cell.showCheckmark = false
                }
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
}


extension FilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = viewModel?.getCategoryModel(at: indexPath.row) else { return }
        let cell = tableView.cellForRow(at: indexPath) as! FilterCell
        cell.showCheckmark = !cell.showCheckmark
        selectedItem.removeAll{$0.strCategory == model.strCategory}
        selectedItem.append(model)
    }
}

