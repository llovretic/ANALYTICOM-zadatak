//
//  RegistartionTableSource.swift
//  Analyticom_Zadatak_v2
//
//  Created by Luka Lovretic on 24/06/2019.
//  Copyright © 2019 llovretic. All rights reserved.
//

import Foundation

public struct RegistartionTableSource{
    let label: String
    let value: String
    var validationState: ValidationState
}

public enum ValidationState{
    case inactive
    case valid
    case invalid
}
