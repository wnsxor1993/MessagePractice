//
//  MessageCollectionViewLayoutDelegate.swift
//  ChatCollection
//
//  Created by Zeto on 2023/01/16.
//

import UIKit

protocol MessageCollectionViewLayoutDelegate: AnyObject {
    
    func collectionView(_ collectionView: UICollectionView, heightForCellAtIndexPath indexPath: IndexPath) -> CGFloat
}

