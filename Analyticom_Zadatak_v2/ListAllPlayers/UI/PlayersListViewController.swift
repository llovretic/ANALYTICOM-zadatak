//
//  PlayersListViewController.swift
//  Analyticom_Zadatak_v2
//
//  Created by Luka Lovretic on 24/06/2019.
//  Copyright © 2019 llovretic. All rights reserved.
//

import UIKit
import RxSwift

class PlayersListViewController: UIViewController, TableRefreshViewController {
    public var viewModel: PlayersListViewModel!
    var disposeBag = DisposeBag()
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.isTranslucent = false
        searchBar.backgroundColor = .lightGray
        return searchBar
    }()
    
    let input = PlayersListViewModel.Input(loadDataSubject: ReplaySubject.create(bufferSize: 1),
                                           searchDataPublisher: ReplaySubject.create(bufferSize: 1))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "COMET Players / List all players"
        setupUI()
        initializeVM()
        input.loadDataSubject.onNext(true)
    }
    
    private func setupUI(){
        view.addSubviews(searchBar,tableView)
        searchBar.delegate = self
        setupConstraints()
        setupTableView()
    }
    
    private func setupConstraints(){
        searchBar.snp.makeConstraints { (maker) in
            maker.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
            maker.height.equalTo(50)
        }
        tableView.snp.makeConstraints { (maker) in
            maker.top.equalTo(searchBar.snp.bottom)
            maker.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.identifier)
        tableView.estimatedRowHeight = 60
    }
    
    private func initializeVM(){
        let output = viewModel.transform(input: input)
        initializeRefreshDriver(refreshObservable: output.refreshView)
        bindSearchInputToPublisher()
    }
    
    private func bindSearchInputToPublisher(){
        @discardableResult let _ = searchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .enumerated()
            .skipWhile({ (index, value) -> Bool in
                return index == 0
            })
            .map({ (index, value) -> String in
                return value
            })
            .debounce(0.3, scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: {[unowned self] (query) in
                self.input.searchDataPublisher.onNext(query)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupCancelButton(){
        let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton
        let cancelButtonAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let attributedString = NSAttributedString(string: cancelButton?.currentTitle ?? "", attributes: cancelButtonAttributes)
        cancelButton?.setAttributedTitle(attributedString, for: .normal)
    }

    
}

extension PlayersListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.output.tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ListTableViewCell = tableView.dequeue(for: indexPath)
        let item = viewModel.output.tableData[indexPath.row]
        cell.configureCell(data: item.data)
        return cell
    }
}

extension PlayersListViewController: UISearchBarDelegate{
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        setupCancelButton()
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        searchBar.text = nil
        input.loadDataSubject.onNext(true)
    }
}
