//
//  HomeViewModel.swift
//  Analyticom_Zadatak_v2
//
//  Created by Luka Lovretic on 24/06/2019.
//  Copyright © 2019 llovretic. All rights reserved.
//

import UIKit
import RxSwift

public class HomeViewModel{
    public weak var delegate: HomeCoordinatorDelegate?
    
    public struct Output: TableRefreshViewModel{
        public var refreshView: PublishSubject<TableRefresh>
        public var tableData: [TableItem<HomeTableType,HomeDataSource>]
    }
    
    public var output: Output!
    
    public init(){
        
    }
    
    public func transform() -> HomeViewModel.Output{
        let output = Output(refreshView: PublishSubject(), tableData: [])
        self.output = output
        initializeDataAndRefreshView()
        return output
    }
    
    public func initializeDataAndRefreshView(){
        self.output.tableData = createTableDataForHomeAndRefreshScreen()
        self.output.refreshView.onNext(.complete)
    }
    
    private func createTableDataForHomeAndRefreshScreen() -> [TableItem<HomeTableType,HomeDataSource>]{
        var tableItems: [TableItem<HomeTableType,HomeDataSource>] = []
        tableItems.append(TableItem(type: HomeTableType.newPlayer,
                                    data: HomeDataSource(data: "New player")))
        tableItems.append(TableItem(type: HomeTableType.list,
                                    data: HomeDataSource(data: "List all players")))
        return tableItems
    }
    
    public func openNextScreen(index: Int){
        let item = self.output.tableData[index]
        switch item.type{
        case .newPlayer:
            delegate?.openPlayerRegistrationScreen()
        case .list:
             delegate?.openPlayersListScreen()
        }
    }
}
