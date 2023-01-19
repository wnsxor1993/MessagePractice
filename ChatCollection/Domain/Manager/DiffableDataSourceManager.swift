//
//  DiffableDataSourceManager.swift
//  ChatCollection
//
//  Created by Zeto on 2023/01/19.
//

import UIKit

final class DiffableDataSourceManager {
    
    private var dataSource: UICollectionViewDiffableDataSource<DiffableSection, ChatDTO>?
    
    private var allSections: [DiffableSection] = []
    private var mainSectionItems: [ChatDTO] = []
    
    let socketManger: SocketIOManager = .init()
    
    init() {
        self.socketManger.connectSocket()
    }
    
    deinit {
        self.socketManger.disconnectSocket()
    }
    
    func setDataSource(_ dataSource: UICollectionViewDiffableDataSource<DiffableSection, ChatDTO>) {
        self.dataSource = dataSource
    }
    
    func sendMessage(text: String, type: ChatType) {
        if allSections.isEmpty || mainSectionItems.isEmpty {
            let newDTO: ChatDTO = .init(chatType: type, message: text, date: .init())
            self.mainSectionItems.append(newDTO)
            
            let mainSection: DiffableSection = .main
            self.allSections.append(mainSection)
            
            var snapshot: NSDiffableDataSourceSnapshot<DiffableSection, ChatDTO> = .init()
            snapshot.appendSections(allSections)
            snapshot.appendItems(mainSectionItems)
            
            DispatchQueue.global(qos: .background).async {
                self.dataSource?.apply(snapshot, animatingDifferences: false)
            }
            
        } else {
            guard let dataSource else { return }
            
            var snapshot = dataSource.snapshot()
            let newDTO: ChatDTO = .init(chatType: type, message: text, date: .init())
            
            self.mainSectionItems.append(newDTO)
            snapshot.appendItems([newDTO])
            
            DispatchQueue.global(qos: .background).async {
                self.dataSource?.apply(snapshot, animatingDifferences: false)
            }
        }
        
        self.socketManger.sendMessage(with: text)
    }
}
