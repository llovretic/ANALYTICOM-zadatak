//
//  PlayerRegistrationViewModel.swift
//  Analyticom_Zadatak_v2
//
//  Created by Luka Lovretic on 24/06/2019.
//  Copyright © 2019 llovretic. All rights reserved.
//

import Foundation
import RxSwift

public typealias TextFieldItem = (data: Any, index: IndexPath)

public class PlayerRegistrationViewModel{
    public struct Input{
        public var textFieldObservable: PublishSubject<TextFieldItem>
        public var saveButtonClicked: PublishSubject<Bool>

    }
    
    public struct Output: TableRefreshViewModel{
        public let disposables: [Disposable]
        public var refreshView: PublishSubject<TableRefresh>
        public var tableData: [RegistrationTableSectionItem<RegistrationSectionType,RegistrationTableType, Any>]
    }
    
    public var output: Output!
    
    public init(){}
    
    public func transform(input: PlayerRegistrationViewModel.Input) -> PlayerRegistrationViewModel.Output{
        var disposables: [Disposable] = []
        disposables.append(initalizeTextFieldObserver(observer: input.textFieldObservable))
        disposables.append(initalizeSaveButtonObserver(observer: input.saveButtonClicked))
        let output = Output(disposables: disposables, refreshView: PublishSubject(), tableData: [])
        self.output = output
        initializeDataAndRefreshView()
        return output
    }
    
    private func initalizeTextFieldObserver(observer: PublishSubject<TextFieldItem>) -> Disposable{
        return observer.subscribe(onNext: { [unowned self](data,index) in
            if var item = self.output.tableData[index.section].items[index.row].data as? RegistartionTableSource{
                let isValid = self.validateField(data: item.value)
                if isValid{
                    item.validationState = .valid
                }else {
                    item.validationState = .invalid
                }
            self.output.tableData[index.section].items[index.row].data = item
                self.output.refreshView.onNext(TableRefresh.reloadRows(indexPaths: [index]))
            }
        })
    }
    
    private func initalizeSaveButtonObserver(observer: PublishSubject<Bool>) -> Disposable{
//        return observer.map({[unowned self] (_) -> (Player, PlayerRegistration) in
//            let player = self.createPlayerItem()
//            let registratration = self.createRegistrationItem()
//            return (player, registratration)
//        })
        return Disposables.create()
    }
    
    private func validateField(data: String) -> Bool{
        if data.isEmpty{
            return false
        }else{
            return true
        }
    }
    
    private func initializeDataAndRefreshView(){
        var tableSections: [RegistrationTableSectionItem<RegistrationSectionType,RegistrationTableType, Any>] = []
        tableSections.append(RegistrationTableSectionItem(type: RegistrationSectionType.general,
                                                          sectionTitle: "General data",
                                                          items: createGeneralTableItems()))
        tableSections.append(RegistrationTableSectionItem(type: RegistrationSectionType.registration,
                                                          sectionTitle: "Registration data",
                                                          items: createRegistrationTableItems()))
        tableSections.append(RegistrationTableSectionItem(type: RegistrationSectionType.save,
                                                          sectionTitle: "",
                                                          items: [TableItem(type: RegistrationTableType.text,
                                                                            data: true)]))
        self.output.tableData = tableSections
        self.output.refreshView.onNext(.complete)
    }
    
    private func createGeneralTableItems() -> [TableItem<RegistrationTableType, Any>]{
        var generalTableItem: [TableItem<RegistrationTableType, Any>] = []
        generalTableItem.append(TableItem(type: RegistrationTableType.text,
                                          data: RegistartionTableSource(label: "ID",
                                                                        value: "",
                                                                        validationState: .inactive)))
        generalTableItem.append(TableItem(type: RegistrationTableType.text,
                                          data: RegistartionTableSource(label: "Unique ID:",
                                                                        value: "",
                                                                        validationState: .inactive)))
        generalTableItem.append(TableItem(type: RegistrationTableType.text,
                                          data: RegistartionTableSource(label: "First name:",
                                                                        value: "",
                                                                        validationState: .inactive)))
        generalTableItem.append(TableItem(type: RegistrationTableType.text,
                                          data: RegistartionTableSource(label: "Last name: ",
                                                                        value: "",
                                                                        validationState: .inactive)))
        generalTableItem.append(TableItem(type: RegistrationTableType.dateInput,
                                          data: RegistartionTableSource(label: "Date of birth",
                                                                        value: "",
                                                                        validationState: .inactive)))
        generalTableItem.append(TableItem(type: RegistrationTableType.text,
                                          data: RegistartionTableSource(label: "Place of birth",
                                                                        value: "",
                                                                        validationState: .inactive)))
        generalTableItem.append(TableItem(type: RegistrationTableType.customInput,
                                          data: RegistartionTableSource(label: "Country",
                                                                        value: "",
                                                                        validationState: .inactive)))
        return generalTableItem
    }
    
    private func createRegistrationTableItems() -> [TableItem<RegistrationTableType, Any>]{
        var registrationTableItems: [TableItem<RegistrationTableType, Any>] = []
        registrationTableItems.append(TableItem(type: RegistrationTableType.customInput,
                                                data: RegistartionTableSource(label: "Club",
                                                                              value: "",
                                                                              validationState: .inactive)))
        registrationTableItems.append(TableItem(type: RegistrationTableType.dateInput,
                                                data: RegistartionTableSource(label: "Date from",
                                                                              value: "",
                                                                              validationState: .inactive)))
        registrationTableItems.append(TableItem(type: RegistrationTableType.dateInput,
                                                data: RegistartionTableSource(label: "Date to",
                                                                              value: "",
                                                                              validationState: .inactive)))
        return registrationTableItems
    }
    
//    private func createPlayerItem() -> Player{
//
//    }
//
//    private func createRegistrationItem() -> PlayerRegistrtion{
//
//    }
}

