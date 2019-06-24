//
//  TableView+Extension.swift
//  Analyticom_Zadatak_v2
//
//  Created by Luka Lovretic on 24/06/2019.
//  Copyright © 2019 llovretic. All rights reserved.
//

import UIKit

extension UITableView {
    
    func dequeue<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        
        guard let cell = self.dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("Can't dequeue cell with identifier: \(T.identifier)")
        }
        
        return cell
    }
    
    func dequeueHeaderFooterView<T: UITableViewHeaderFooterView>() -> T {
        
        guard let view = self.dequeueReusableHeaderFooterView(withIdentifier: T.identifier) as? T else {
            fatalError("Can't dequeue view with identifier: \(T.identifier)")
        }
        
        return view
    }
}
extension UITableViewHeaderFooterView: Identifiable{
    
}
extension UITableViewCell: Identifiable{
    
}
