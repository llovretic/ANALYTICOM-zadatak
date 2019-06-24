//
//  ViewController.swift
//  Analyticom_Zadatak_v2
//
//  Created by Luka Lovretic on 24/06/2019.
//  Copyright © 2019 llovretic. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit

class HomeViewController: UIViewController, TableRefreshViewController {
    var disposeBag = DisposeBag()
    
    var viewModel: HomeViewModel!
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "COMET Players"
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
            maker.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.identifier)
        tableView.estimatedRowHeight = 50
    }
    
    private func initializeVM(){
        let output = viewModel.transform()
        initializeRefreshDriver(refreshObservable: output.refreshView)
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HomeTableViewCell = tableView.dequeue(for: indexPath)
        let item = viewModel.output.tableData[indexPath.row]
        cell.configureCell(data: item.data.data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.openNextScreen(index: indexPath.row)
    }
}

