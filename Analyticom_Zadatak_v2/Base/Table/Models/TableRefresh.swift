//
//  TableRefresh.swift
//  Analyticom_Zadatak_v2
//
//  Created by Luka Lovretic on 24/06/2019.
//  Copyright © 2019 llovretic. All rights reserved.
//

import UIKit
public enum TableRefresh: Equatable {
    case complete
    case reloadRows(indexPaths: [IndexPath])
    case updateRows(indexPaths: [IndexPath])
    case section(section: Int, withAnimation: UITableView.RowAnimation )
    case dontRefresh
}
