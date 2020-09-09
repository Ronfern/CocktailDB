//
//  ViewController.swift
//  CocktailDB
//
//  Created by Роман Чугай on 07.09.2020.
//  Copyright © 2020 Роман Чугай. All rights reserved.
//

import UIKit

class DrinkViewController: UIViewController {
    
    @IBOutlet weak var mainTableView: UITableView!{
        didSet {
            mainTableView.delegate = self
            mainTableView.dataSource = self
            mainTableView.register(UINib(nibName: String(describing: DrinkCell.self), bundle: nil), forCellReuseIdentifier: String(describing: DrinkCell.self))
            mainTableView.register(UINib(nibName: String(describing: LoadMoreCell.self), bundle: nil), forCellReuseIdentifier: String(describing: LoadMoreCell.self))
        }
    }
    // private
    private var viewModel: DrinkViewModel?
    private var tableviewPaginator: TableviewPaginator?
    private var limit = 100
    
    override func viewDidLoad() {
        viewModel = DrinkViewModel(delegate: self)
        tableviewPaginator = TableviewPaginator(paginatorUI: self, delegate: self)
        tableviewPaginator?.initialSetup()
    }
    
    @IBAction private func filterButtonTapped(_ sender: Any) {
        
    }
}

extension DrinkViewController: TableviewPaginatorUIProtocol {
    func getTableview(paginator: TableviewPaginator) -> UITableView {
        return mainTableView
    }
    
    func shouldAddRefreshControl(paginator: TableviewPaginator) -> Bool {
        return false
    }
    
    func getPaginatedLoadMoreCellHeight(paginator: TableviewPaginator) -> CGFloat {
        return 44
    }
    
    func getPaginatedLoadMoreCell(paginator: TableviewPaginator) -> UITableViewCell {
        if let cell = mainTableView.dequeueReusableCell(withIdentifier: String(describing: LoadMoreCell.self))
            as? LoadMoreCell {
            cell.activityIndicator.startAnimating()
            cell.activityIndicator.isHidden = false
            return cell
        } else {
            return UITableViewCell.init()
        }
    }
    
    func getRefreshControlTintColor(paginator: TableviewPaginator) -> UIColor {
        return .clear
    }
    
}

extension DrinkViewController: TableviewPaginatorProtocol {
    
    func loadPaginatedData(offset: Int, shouldAppend: Bool, paginator: TableviewPaginator) {
        viewModel?.fetchDrinks(offset: offset, limit: limit, shouldAppend: shouldAppend)
    }
}

extension DrinkViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x:20, y:0, width:tableView.frame.size.width, height:18))
        let label = UILabel(frame: CGRect(x:20, y:5, width:tableView.frame.size.width, height:18))
        label.font = UIFont.init(name: "Roboto-Regular", size: 14)
        label.text = viewModel?.getCategory(at: section)
        label.textColor = #colorLiteral(red: 0.4940612912, green: 0.4941501021, blue: 0.4940556288, alpha: 1)
        view.addSubview(label);
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSections() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel?.numberOfRows(section: section) ?? 0) + (tableviewPaginator?.rowsIn(section: section) ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableviewPaginator?.cellForLoadMore(at: indexPath) {
            return cell
        }
 
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DrinkCell.self)) as? DrinkCell {
            cell.customize(model: viewModel?.getDrink(in: indexPath.section, at: indexPath.row))
            return cell
        } else {
            return UITableViewCell()
        }
        
    }
    
}

extension DrinkViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tableviewPaginator?.scrollViewDidScroll(scrollView)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = tableviewPaginator?.heightForLoadMore(cell: indexPath) {
            return height
        }
        return 147
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension DrinkViewController: DrinkViewModelProtocol {
    func drinksFetched(success: Bool, drinkCount: Int) {
        
        if success {
            tableviewPaginator?.incrementOffsetBy(delta: drinkCount)
        }
        tableviewPaginator?.partialDataFetchingDone()
        mainTableView.reloadData()
    }
}




