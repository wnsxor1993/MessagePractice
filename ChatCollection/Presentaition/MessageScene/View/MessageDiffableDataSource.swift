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
    
    var hasSnapshot: Bool {
        guard let dataSource else { return false }
        
        if dataSource.snapshot().numberOfSections == 0 {
            return false
        } else {
            return true
        }
    }
    
    init(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
        
        self.configureDataSource()
    }
    
    func fetchBaseDatas(with sections: [DiffableSection: [ChatDTO]]) {
        var snapshot: NSDiffableDataSourceSnapshot<DiffableSection, ChatDTO> = .init()
        
        let allKeys = sections.map { $0.key }
        snapshot.appendSections(allKeys)
        
        allKeys.forEach {
            guard let items = sections[$0] else { return }
            
            snapshot.appendItems(items, toSection: $0)
        }
        
        DispatchQueue.global(qos: .background).async {
            self.dataSource?.apply(snapshot, animatingDifferences: false)
        }
    }
    
    func addItems(with sections: [DiffableSection: [ChatDTO]]) {
        guard let dataSource else { return }
        
        let allKeys = sections.map { $0.key }
        var snapshot = dataSource.snapshot()
        
        allKeys.forEach {
            guard let items = sections[$0] else { return }
            
            snapshot.appendItems(items, toSection: $0)
        }
        
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
