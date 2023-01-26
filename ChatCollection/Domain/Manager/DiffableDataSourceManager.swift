//
//  DiffableDataSourceManager.swift
//  ChatCollection
//
//  Created by Zeto on 2023/01/19.
//

import UIKit
import RxSwift

final class DiffableDataSourceManager {
    
    private var allSections: [DiffableSection] = []
    private var allItems: [DiffableSection: [ChatDTO]] = [:]
    
    let socketManger: SocketIOManager = .init()
    
    init() {
        self.socketManger.connectSocket()
    }
    
    deinit {
        self.socketManger.disconnectSocket()
    }
    
    func fetchPreviousMessages() -> Observable<[DiffableSection: [ChatDTO]]> {
        // API 통신으로 이전 메세지들 받아오고 데이터 앞에다 추가해주기
        // 섹션 별로 받을 지, 아니면 그냥 무작위 범위일 지 모름
        // 해당 로직은 대충 예시
        
        if allSections.isEmpty {
            allSections.append(.main)
            allItems[.main] = []
            
        } else {
            allSections.insert(.main, at: 0)
        }
        
        return Observable.create { [weak self] observer -> Disposable in
            guard let self else { return Disposables.create() }
            
            observer.onNext(self.allItems)

            return Disposables.create()
        }
    }
    
    func sendMessage(text: String) -> Observable<[DiffableSection: [ChatDTO]]> {
        guard let lastSection = allSections.last else { return .empty() }
        
        self.socketManger.sendMessage(with: text)
        
        let chatDTO: ChatDTO = .init(chatType: .send, message: text, date: .init())
        allItems[lastSection]?.append(chatDTO)
        
        return Observable.create { [weak self] observer -> Disposable in
            guard let self else { return Disposables.create() }
            
            observer.onNext(self.allItems)

            return Disposables.create()
        }
    }
}
