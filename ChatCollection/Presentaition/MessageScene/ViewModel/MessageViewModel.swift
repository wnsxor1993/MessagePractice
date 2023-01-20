//
//  MessageViewModel.swift
//  ChatCollection
//
//  Created by Zeto on 2023/01/19.
//

import RxSwift
import RxCocoa

final class MessageViewModel {
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    private let dataSourceManager: DiffableDataSourceManager = .init()
    
    private let disposeBag: DisposeBag = .init()
    
    func setDiffableDataSource(_ dataSource: UICollectionViewDiffableDataSource<DiffableSection, ChatDTO>) {
        self.dataSourceManager.setDataSource(dataSource)
    }
}
