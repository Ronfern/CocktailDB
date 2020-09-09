//
//  TableViewPaginator.swift
//  CocktailDB
//
//  Created by Роман Чугай on 07.09.2020.
//  Copyright © 2020 Роман Чугай. All rights reserved.
//

import UIKit

public protocol TableviewPaginatorUIProtocol: class {
    func getTableview(paginator: TableviewPaginator) -> UITableView
    func shouldAddRefreshControl(paginator: TableviewPaginator) -> Bool
    func getPaginatedLoadMoreCellHeight(paginator: TableviewPaginator) -> CGFloat
    func getPaginatedLoadMoreCell(paginator: TableviewPaginator) -> UITableViewCell
    func getRefreshControlTintColor(paginator: TableviewPaginator) -> UIColor
}

public protocol TableviewPaginatorProtocol: class {
    func loadPaginatedData(offset: Int, shouldAppend: Bool, paginator: TableviewPaginator)
}

public class TableviewPaginator {

    public struct PaginatorState {
        public var offset: Int = 0
        public var dataFetchingRunning: Bool = false
        public var allDataFetchingCompleted: Bool = false
        var isAllRowSeeked: Bool = false
    }

    private var refreshControl: UIRefreshControl?
    public private(set) var state: PaginatorState = PaginatorState()
    private weak var paginatorUI: TableviewPaginatorUIProtocol?
    private weak var delegate: TableviewPaginatorProtocol?

    private static let defaultSections = 1
    private static let defaultRows = 0

    
    required public init(paginatorUI: TableviewPaginatorUIProtocol, delegate: TableviewPaginatorProtocol) {
        self.delegate = delegate
        self.paginatorUI = paginatorUI
    }
    
    public func initialSetup() {
        setupRefreshControl()
        refreshControlPulled()
    }
    
    private func setupRefreshControl() {
        if paginatorUI?.shouldAddRefreshControl(paginator: self) ?? false {
            let refreshControl = UIRefreshControl()
            refreshControl.tintColor = paginatorUI?.getRefreshControlTintColor(paginator: self)
            paginatorUI?.getTableview(paginator: self).addSubview(refreshControl)
            refreshControl.addTarget(self, action: #selector(refreshControlPulled), for: .valueChanged)
            self.refreshControl = refreshControl
        }
    }

    @objc func refreshControlPulled() {
        refresh()
    }
    
    public func refresh() {
        state.dataFetchingRunning = true
        state.allDataFetchingCompleted = false
        state.offset = 0
        self.delegate?.loadPaginatedData(offset: state.offset, shouldAppend: false, paginator: self)
    }

    public func rowsIn(section: Int) -> Int {
        return (isLastSection(section: section) && state.allDataFetchingCompleted == false) ? 1 : 0
    }

    public func heightForLoadMore(cell indexPath: IndexPath) -> CGFloat? {
        if  state.allDataFetchingCompleted == false,
            isLastSectionRow(indexPath: indexPath) {// it's the last row of this section
            return paginatorUI?.getPaginatedLoadMoreCellHeight(paginator: self)
        } else {
            return nil
        }
    }

    public func cellForLoadMore(at indexPath: IndexPath) -> UITableViewCell? {
        if  state.allDataFetchingCompleted == false,
            isLastSectionRow(indexPath: indexPath) {// it's the last row of this section
            state.isAllRowSeeked = true
            return paginatorUI?.getPaginatedLoadMoreCell(paginator: self)
        } else {
            return nil
        }
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let  height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height,
            state.dataFetchingRunning == false, state.allDataFetchingCompleted == false,
            state.isAllRowSeeked == true {
            state.dataFetchingRunning = true
            state.isAllRowSeeked = false
            self.delegate?.loadPaginatedData(offset: state.offset, shouldAppend: true, paginator: self)
        }
    }

    public func incrementOffsetBy(delta: Int) {
        state.offset += delta

        if delta == 0 {
            state.allDataFetchingCompleted = true
        }
    }

    public func partialDataFetchingDone() {
        refreshControl?.endRefreshing()
        state.dataFetchingRunning = false
    }

    public func isLastSectionRow(indexPath: IndexPath) -> Bool {
        if let tableview = paginatorUI?.getTableview(paginator: self) {
            let lastSection = tableview.dataSource?.numberOfSections?(in: tableview)
                ?? TableviewPaginator.defaultSections
            let lastRow = tableview.dataSource?.tableView(tableview,
                                                          numberOfRowsInSection: indexPath.section)
                ?? TableviewPaginator.defaultRows

            return lastSection == (indexPath.section+1) && lastRow == (indexPath.row+1)
        } else {
            return false
        }
    }

    public func isLastSection(section: Int) -> Bool {
        if let tableview = paginatorUI?.getTableview(paginator: self) {
            return ((section + 1) == tableview.dataSource?.numberOfSections?(in: tableview)
                ?? TableviewPaginator.defaultSections )
        } else {
            return false
        }
    }
}
