//
//  RxDataSourceManager.swift
//  ChatCollection
//
//  Created by Zeto on 2023/01/18.
//

import RxDataSources
import RxRelay

final class RxDataSourceManager {
    
    static let shared: RxDataSourceManager = .init()
    
//    private let socketManager: WebSocketManager = .init()
    private let socketManager: SocketIOManager = .init()
    
    private var allSections: [SectionModel] = []
    
    private var mainSection: SectionModel?
    private var mainSectionItems: [ChatModel] = []
    
    private init() {
//        self.socketManager.connectSocket()
//        self.socketManager.connect()
    }
    
    deinit {
//        self.socketManager.disconnectSocket()
//        self.socketManager.disConnect()
    }
    
    func fetchSectionModels() -> [SectionModel] {
        
        return self.allSections
    }
    
    func sendMessage(text: String) {
//        self.socketManager.sendMessage(with: text)
//        self.socketManager.sendMessage(text)
        
        let newDTO: ChatModel = .init(chatType: .send, message: text, date: .init())
        mainSectionItems.append(newDTO)
        
        var sectionModel: SectionModel = .init(header: "Main", items: mainSectionItems)
        
        if let mainSection {
            sectionModel = .init(original: mainSection, items: mainSectionItems)
            self.mainSection = sectionModel
            
        } else {
            self.mainSection = sectionModel
        }
        
        self.allSections = [sectionModel]
    }
}
