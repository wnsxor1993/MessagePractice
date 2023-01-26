//
//  ChatDTO.swift
//  ChatCollection
//
//  Created by Zeto on 2023/01/19.
//

import Foundation

struct ChatDTO: Hashable {
    
    let chatType: ChatType
    let message: String
    let date: Date
}
