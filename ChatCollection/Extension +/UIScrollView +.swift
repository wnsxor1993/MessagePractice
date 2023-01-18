//
//  UIScrollView +.swift
//  ChatCollection
//
//  Created by Zeto on 2023/01/18.
//

import UIKit

extension UICollectionView {
    
    /// Last Section of the CollectionView
    var lastSection: Int {
        return numberOfSections - 1
    }
    
    /// IndexPath of the last item in last section.
    var lastIndexPath: IndexPath? {
        guard lastSection >= 0 else {
            return nil
        }
        
        let lastItem = numberOfItems(inSection: lastSection) - 1
        guard lastItem >= 0 else {
            return nil
        }
        
        return IndexPath(item: lastItem, section: lastSection)
    }
    
    func scrollToBottom(animated: Bool) {
        guard let lastIndexPath = lastIndexPath else {
            return
        }
        
        scrollToItem(at: lastIndexPath, at: .bottom, animated: animated)
    }
}
