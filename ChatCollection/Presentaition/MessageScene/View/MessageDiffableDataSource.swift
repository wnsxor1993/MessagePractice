//
//  MessageDiffableDataSource.swift
//  ChatCollection
//
//  Created by Zeto on 2023/01/19.
//

import UIKit

final class MessageDiffableDataSource {
    
    private let collectionView: UICollectionView
    private var dataSource: UICollectionViewDiffableDataSource<DiffableSection, ChatDTO>?
    
    init(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
        
        self.configureDataSource()
    }
    
    func fetchBaseDatas(with sections: [DiffableSection], items: [[ChatDTO]]) {
        var snapshot: NSDiffableDataSourceSnapshot<DiffableSection, ChatDTO> = .init()
        snapshot.appendSections(sections)
        
        for (index, section) in sections.enumerated() {
            guard let item = items[safe: index] else { return }
            
            snapshot.appendItems(item, toSection: section)
        }
        
        DispatchQueue.global(qos: .background).async {
            self.dataSource?.apply(snapshot, animatingDifferences: false)
        }
    }
    
    func addItems(to section: DiffableSection, with items: [ChatDTO]) {
        guard let dataSource else { return }
        
        var snapshot = dataSource.snapshot()
        snapshot.appendItems(items, toSection: section)
        
        DispatchQueue.global(qos: .background).async {
            self.dataSource?.apply(snapshot, animatingDifferences: false)
        }
    }
}

private extension MessageDiffableDataSource {
    
    func configureDataSource() {
        self.dataSource = .init(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            var identifier = ""
            
            switch item.chatType {
            case .none:
                break
                
            case .send:
                identifier = SendCell.identifier
                
            case .receive:
                identifier = ReceiveCell.identifier
            }
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? MessageCell else { return .init() }
            
            let formatter: MessageDateFormatter = .init()
            let dateString: String = formatter.convertToString(from: item.date)
            
            cell.setCell(with: item.message, dateString: dateString)
            
            return cell
        }
        
        guard let dataSource else { return }
        
        self.collectionView.dataSource = dataSource
    }
}
