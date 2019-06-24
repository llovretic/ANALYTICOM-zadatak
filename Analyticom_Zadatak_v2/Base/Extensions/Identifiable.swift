//
//  Identifiable.swift
//  Analyticom_Zadatak_v2
//
//  Created by Luka Lovretic on 24/06/2019.
//  Copyright © 2019 llovretic. All rights reserved.
//

import UIKit
protocol Identifiable{
    
}
extension Identifiable {
    static var identifier: String {
        return String(describing: self)
    }
}
