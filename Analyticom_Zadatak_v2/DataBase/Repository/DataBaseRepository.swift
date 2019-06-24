//
//  DataBaseRepository.swift
//  Analyticom_Zadatak_v2
//
//  Created by Luka Lovretic on 24/06/2019.
//  Copyright © 2019 llovretic. All rights reserved.
//

import RxSwift
import RealmSwift

class DataBaseRepository: RealmApi, DataBaseRepositoryProtocol{
    func getPlayer(query: String) -> Observable<Player> {
        return Observable.just(Player())
    }
    
    func getCountries() -> Observable<[Country]> {
        return Observable.just([Country]())
    }
    
    func getClubs() -> Observable<[Clubs]> {
        return runRealmOperation(realmOperation: { (realm) -> Observable<[ThreadSafeReference<Clubs>]> in
            let clubs = realm.objects(Clubs.self).map({ (club) -> ThreadSafeReference<Clubs> in
                return ThreadSafeReference(to: club)
            })
            return Observable.just(Array(clubs))
        }).observeOn(MainScheduler.instance)
            .map({ (threadSafeClubs) -> [Clubs] in
                threadSafeClubs.compactMap({[unowned self] (threadSafeClub) -> Clubs? in
                    return self.mapThreadSafeObservable(threadSafeData: threadSafeClub, observeOnScheduler: MainScheduler.instance)
                })
            })
    }
    
    func getAllPlayers() -> Observable<[Player]>{
        return runRealmOperation(realmOperation: { (realm) -> Observable<[ThreadSafeReference<Player>]> in
            let players = realm.objects(Player.self).map({ (player) -> ThreadSafeReference<Player> in
                return ThreadSafeReference(to: player)
            })
            return Observable.just(Array(players))
        }).observeOn(MainScheduler.instance)
            .map({ (threadSafePlayers) -> [Player] in
            threadSafePlayers.compactMap({[unowned self] (threadSafePlayer) -> Player? in
                return self.mapThreadSafeObservable(threadSafeData: threadSafePlayer, observeOnScheduler: MainScheduler.instance)
            })
        })
    }
    
    func getRegistrationForPlayer() -> Observable<[PlayerRegistrtion]>{
        return runRealmOperation(realmOperation: { (realm) -> Observable<[ThreadSafeReference<PlayerRegistrtion>]> in
            let playerRegistrations = realm.objects(PlayerRegistrtion.self).map({ (playerRegistration) -> ThreadSafeReference<PlayerRegistrtion> in
                return ThreadSafeReference(to: playerRegistration)
                })
            return Observable.just(Array(playerRegistrations))
        }).observeOn(MainScheduler.instance)
            .map({ (threadSafePlayersRegistrations) -> [PlayerRegistrtion] in
                threadSafePlayersRegistrations.compactMap({ [unowned self] (threadSafePlayersRegistration) -> PlayerRegistrtion? in
                    return self.mapThreadSafeObservable(threadSafeData: threadSafePlayersRegistration, observeOnScheduler: MainScheduler.instance)
                })
            })
    }
    
    
    public func addDataToDataBase<T: Object>(data: [T]) -> Observable<Bool> {
        return runRealmOperation(realmOperation: {(realm) -> Observable<Bool> in
            realm.beginWrite()
            realm.add(data)
            try realm.commitWrite()
            return Observable.just(true)
        })
    }

}

protocol DataBaseRepositoryProtocol{
    func getPlayer(query: String) -> Observable<Player>
    func getAllPlayers() -> Observable<[Player]>
    func getCountries() -> Observable<[Country]>
    func getClubs() -> Observable<[Clubs]>
    func getRegistrationForPlayer() -> Observable<[PlayerRegistrtion]>
}
