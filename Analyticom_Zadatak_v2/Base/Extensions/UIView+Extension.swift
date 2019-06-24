//
//  UIView+Extension.swift
//  Analyticom_Zadatak_v2
//
//  Created by Luka Lovretic on 24/06/2019.
//  Copyright © 2019 llovretic. All rights reserved.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...){
        for view in views{
            self.addSubview(view)
        }
    }
}
