//
//  PlayerRegistrationViewController.swift
//  Analyticom_Zadatak_v2
//
//  Created by Luka Lovretic on 24/06/2019.
//  Copyright © 2019 llovretic. All rights reserved.
//

import UIKit
import RxSwift

class PlayerRegistrationViewController: UIViewController, TableRefreshViewController {
    public var viewModel: PlayerRegistrationViewModel!
    
    var disposeBag = DisposeBag()
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let input = PlayerRegistrationViewModel.Input(textFieldObservable: PublishSubject(), saveButtonClicked: PublishSubject())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "COMET Players / New player"
        setupUI()
        initializeVM()
    }
    private func setupUI(){
        view.addSubview(tableView)
        setupConstraints()
        setupTableView()
    }
    
    private func setupConstraints(){
        tableView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
        }
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(NewPlayerTableViewCell.self, forCellReuseIdentifier: NewPlayerTableViewCell.identifier)
        tableView.register(ButtonTableViewCell.self, forCellReuseIdentifier: ButtonTableViewCell.identifier)
        tableView.register(NewPlayerHeaderView.self, forHeaderFooterViewReuseIdentifier: NewPlayerHeaderView.identifier)
        tableView.estimatedRowHeight = 44
    }
    
    private func initializeVM(){
        let output = viewModel.transform(input: input)
        initializeRefreshDriver(refreshObservable: output.refreshView)
    }
    
    public func initializeRefreshDriver(refreshObservable: Observable<TableRefresh>) {
        refreshObservable
            .asDriver(onErrorJustReturn: TableRefresh.dontRefresh)
            .do(onNext: { [unowned self] (tableRefresh) in
                switch tableRefresh{
                case .updateRows(let indexes):
                    self.updateRows(indexes)
                default:
                    self.reloadTable(tableRefresh: tableRefresh, tableView: self.tableView)
                }
            })
            .drive()
            .disposed(by: disposeBag)
        
    }

    
    private func updateRows(_ changedIndexes:[IndexPath]){
        var updateData:[IndexPath:UITableViewCell] = [:]
        /**
         get only cells that are currently visible and update it's content.
         */
        for visibleCell in  self.tableView.visibleCells {
            let cellIndex = tableView.indexPath(for: visibleCell)
            for changedIndex in changedIndexes {
                if( cellIndex == changedIndex){
                    updateData[changedIndex] = visibleCell
                }
            }
        }
        tableView.beginUpdates()
        for mapValue in updateData {
            let cell = mapValue.value
            if  let item = viewModel.output.tableData[mapValue.key.section].items[mapValue.key.row].data as? RegistartionTableSource,
                let textCell = cell as? NewPlayerTableViewCell {
                let type = viewModel.output.tableData[mapValue.key.section].items[mapValue.key.row].type
                textCell.configureCell(data: item, type: type)
            }
            if  let item = viewModel.output.tableData[mapValue.key.section].items[mapValue.key.row].data as? Bool,
                let textCell = cell as? ButtonTableViewCell {
                textCell.configureCell(isEnable: item)
                
            }
            tableView.endUpdates()
        }
    }

}

extension PlayerRegistrationViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.output.tableData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.tableData[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tableCell: UITableViewCell
        let section = viewModel.output.tableData[indexPath.section]
        let item = viewModel.output.tableData[indexPath.section].items[indexPath.row]
        switch section.type{
        case .general, .registration:
            switch item.type{
            case .text:
                let cell: NewPlayerTableViewCell = tableView.dequeue(for: indexPath)
                if let data = item.data as? RegistartionTableSource{
                    cell.configureCell(data: data, type: .text)
                }
                cell.setupPublisher()
                cell.onTextEdit = { [unowned self] (data) in
                    self.updateTableData(for: cell, action: { [unowned self] indexPath in
                        self.input.textFieldObservable.onNext((index: indexPath, data: (data)))
                    })
                }
                
                tableCell = cell
            case .dateInput:
                let cell: NewPlayerTableViewCell = tableView.dequeue(for: indexPath)
                if let data = item.data as? RegistartionTableSource{
                    cell.configureCell(data: data, type: .dateInput)
                }
                cell.setupPublisher()
                cell.onTextEdit = { [unowned self] (data) in
                    self.updateTableData(for: cell, action: { [unowned self] indexPath in
                        self.input.textFieldObservable.onNext((index: indexPath, data: (data) as Any))
                    })
                }
                tableCell = cell
            case .customInput:
                let cell: NewPlayerTableViewCell = tableView.dequeue(for: indexPath)
                if let data = item.data as? RegistartionTableSource{
                    cell.configureCell(data: data, type: .customInput)
                }
                cell.setupPublisher()
                cell.onTextEdit = { [unowned self] (data) in
                    self.updateTableData(for: cell, action: { [unowned self] indexPath in
                        self.input.textFieldObservable.onNext((index: indexPath, data: (data) as Any))
                    })
                }
                tableCell = cell
            }

        case .save:
            let cell: ButtonTableViewCell = tableView.dequeue(for: indexPath)
            if let data = item.data as? Bool{
                cell.configureCell(isEnable: data)
            }
            cell.onButtonClick = { 
                    self.input.saveButtonClicked.onNext(true)
            }

            tableCell = cell

        }
        
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = viewModel.output.tableData[section]
        switch section.type{
        case .general,.registration:
            let header: NewPlayerHeaderView = tableView.dequeueHeaderFooterView()
            header.sectionTitleLabel.text = section.sectionTitle
            return header
        case .save:
            return UIView()
        }
        
    }
    
    func updateTableData(for cell: UITableViewCell, action:((_ indexPath: IndexPath)->Void)) {
        guard let indexPath = self.tableView.indexPath(for: cell) else {
            return
        }
        action(indexPath)
    }

}
