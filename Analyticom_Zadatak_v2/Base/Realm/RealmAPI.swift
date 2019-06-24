//
//  RealmAPI.swift
//  Analyticom_Zadatak_v2
//
//  Created by Luka Lovretic on 24/06/2019.
//  Copyright © 2019 llovretic. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
class RealmApi {
    func runRealmOperation<T>(  realmOperation :  (_ realm:Realm) throws ->Observable<T>)  ->Observable<T> {
        do{
            let realm = try Realm() 
            return try realmOperation(realm)
            
        }catch let exception{
            debugPrint(exception)
            return Observable.error(exception)
        }
    }
    
    func mapThreadSafeObservable<T>(threadSafeData : ThreadSafeReference<T>,observeOnScheduler : SchedulerType) -> T? {
        do{
            let realm = try Realm()
            return realm.resolve(threadSafeData)
            
        }catch let exception{
            debugPrint(exception)
            return nil
        }
}
}
