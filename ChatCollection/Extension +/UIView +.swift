//
//  UIView +.swift
//  ChatCollection
//
//  Created by Zeto on 2023/01/16.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        views.forEach {
            self.addSubview($0)
        }
    }
}
