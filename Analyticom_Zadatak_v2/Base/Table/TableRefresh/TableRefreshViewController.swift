//
//  TableRefreshViewController.swift
//  Analyticom_Zadatak_v2
//
//  Created by Luka Lovretic on 24/06/2019.
//  Copyright © 2019 llovretic. All rights reserved.
//

import RxSwift
import RxCocoa
protocol TableRefreshViewController {
    var tableView: UITableView {get}
    var disposeBag: DisposeBag {get}
    func initializeRefreshDriver(refreshObservable: Observable<TableRefresh>)
}

extension TableRefreshViewController where  Self:UIViewController{
    
    internal func initializeRefreshDriver(refreshObservable: Observable<TableRefresh>){
        refreshObservable
            .asDriver(onErrorJustReturn: TableRefresh.dontRefresh)
            .do(onNext: { [unowned self] (tableRefresh) in
                self.reloadTable(tableRefresh: tableRefresh, tableView: self.tableView)
            })
            .drive()
            .disposed(by: disposeBag)
    }
    func reloadTable(tableRefresh: TableRefresh, tableView: UITableView){
        switch(tableRefresh){
        case .complete:
            debugPrint("reloading table for \(self)")
            tableView.reloadData()
        case .section(let index, let animation):
            let index = IndexSet(integer: index)
            tableView.reloadSections(index, with: animation)
            debugPrint("reloading table section with index : \(index) for \(self)")
        case .reloadRows(let indexPaths):
            debugPrint("reloading table rows with index : \(indexPaths) for \(self)")
            tableView.reloadRows(at: indexPaths, with: .none)
        default:
            return
        }
    }
}
