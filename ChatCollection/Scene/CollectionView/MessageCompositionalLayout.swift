//
//  Layout.swift
//  ChatCollection
//
//  Created by Zeto on 2023/01/17.
//

import UIKit

struct MessageCompositionalLayout {
    
    var compositionalLayoutSection: UICollectionViewCompositionalLayout? {
        guard let collectionLayout = self.createCalendarLayout() else { return nil }
        
        return UICollectionViewCompositionalLayout(section: collectionLayout)
    }
}

private extension MessageCompositionalLayout {
    
    func createCalendarLayout() -> NSCollectionLayoutSection? {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        
        return section
    }
}
