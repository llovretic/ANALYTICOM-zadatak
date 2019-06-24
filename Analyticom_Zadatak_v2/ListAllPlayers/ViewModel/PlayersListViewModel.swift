//
//  PlayersListViewModel.swift
//  Analyticom_Zadatak_v2
//
//  Created by Luka Lovretic on 24/06/2019.
//  Copyright © 2019 llovretic. All rights reserved.
//

import Foundation
import RxSwift

public class PlayersListViewModel{
    public struct Dependecies{
        let dataBaseRepository: DataBaseRepositoryProtocol
    }
    
    public struct Input{
        public let loadDataSubject: ReplaySubject<Bool>
        public let searchDataPublisher: ReplaySubject<String>
    }
    
    public struct Output: TableRefreshViewModel{
        var refreshView: PublishSubject<TableRefresh>
        public var disposables: [Disposable]
        public var tableData: [TableItem<PlayersListTableType,PlayersListDataSource>]
        
    }
    
    public var output: Output!
    
    public init(){}
    
    public func transform(input: PlayersListViewModel.Input) -> PlayersListViewModel.Output{
        var disposables: [Disposable] = []
        disposables.append(initializePlayersData(dataSubject: input.loadDataSubject))
        disposables.append(initializeSearchDataPublisher(searchPublish: input.searchDataPublisher))
        let output = Output(refreshView: PublishSubject(),
                            disposables: disposables,
                            tableData: [])
        self.output = output
        return output
    }
    
    private func initializePlayersData(dataSubject: ReplaySubject<Bool>) -> Disposable{
        return dataSubject.flatMap({ (_) -> Observable<([Player],[PlayerRegistrtion],[Clubs])> in
            let playersObservable = DataBaseRepository().getAllPlayers()
            let playerRegistrationObservable = DataBaseRepository().getRegistrationForPlayer()
            let clubsObservable = DataBaseRepository().getClubs()
            return Observable.combineLatest(playersObservable, playerRegistrationObservable, clubsObservable)
            
        })
            .map({ (players, playersRegistration, clubs) -> [TableItem<PlayersListTableType,PlayersListDataSource>] in
                return self.createTableData(players: players, playersRegistration: playersRegistration, clubs: clubs)
            })
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: {[unowned self] (players) in
                self.output.tableData = players
                self.output.refreshView.onNext(.complete)
            })
        
    }
    
    private func initializeSearchDataPublisher(searchPublish: ReplaySubject<String>)->Disposable{
        return searchPublish.map({ [unowned self](name) -> [TableItem<PlayersListTableType,PlayersListDataSource>] in
            return self.createSerachItems(query: name)
        }).observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: {[unowned self] (players) in
                self.output.tableData = players
                self.output.refreshView.onNext(.complete)
            })
            
        }
    private func createSerachItems(query: String) -> [TableItem<PlayersListTableType,PlayersListDataSource>]{
        var dataSource: [TableItem<PlayersListTableType,PlayersListDataSource>] = []
        let items = self.output.tableData.map { (tableItem) -> PlayersListDataSource in
            return tableItem.data
        }
        for item in items{
            if item.name.contains(query){
                dataSource.append(TableItem(type: .general, data: item))
            }
        }
        return dataSource
    }
    
    private func createTableData(players: [Player], playersRegistration: [PlayerRegistrtion], clubs: [Clubs]) -> [TableItem<PlayersListTableType,PlayersListDataSource>]{
        var dataSource: [TableItem<PlayersListTableType,PlayersListDataSource>] = []
        for player in players{
            let playersRegistration = playersRegistration.first { (playerRegistration) -> Bool in
                return playerRegistration.playerId == player.id
            }
            dataSource.append(TableItem(type: .general, data: PlayersListDataSource(name: createNameData(firstName: player.firstName,
                                                                                                         lastName: player.lastName),
                                                                                    club: getClubNameForPlayer(clubs: clubs,
                                                                                                               clubId: playersRegistration!.clubId),
                                                                                    dateFrom: playersRegistration!.dateFrom,
                                                                                    dateTo: playersRegistration!.dateTo)))
        }
        return dataSource
    }
    
    private func createNameData(firstName: String, lastName: String) -> String{
        return firstName + " " + lastName
    }
    
    private func getClubNameForPlayer(clubs: [Clubs], clubId: Int) -> String{
        let club = clubs.first { (club) -> Bool in
            return club.id == clubId
        }
        return (club!.type + " " + club!.name)
    }
    
    
}
