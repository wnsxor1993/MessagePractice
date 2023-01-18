//
//  ChatDTO.swift
//  ChatCollection
//
//  Created by Zeto on 2023/01/16.
//

import RxDataSources

struct ChatModel {
    
    let chatType: ChatType
    let message: String
    let date: Date
}

extension ChatModel: IdentifiableType, Equatable {
    
    typealias Identity = String
    
    var identity: String {
        
        return UUID().uuidString
    }
}
