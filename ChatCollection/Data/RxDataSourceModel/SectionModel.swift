//
//  SectionModel.swift
//  ChatCollection
//
//  Created by Zeto on 2023/01/18.
//

import RxDataSources

struct SectionModel {
    
    var header: String
    var items: [ChatModel]
}

extension SectionModel: AnimatableSectionModelType {
    
    typealias Item = ChatModel
    typealias Identity = String
    
    var identity: String {
        
        return header
    }
    
    init(original: SectionModel, items: [ChatModel]) {
        self = original
        self.items = items
    }
}
