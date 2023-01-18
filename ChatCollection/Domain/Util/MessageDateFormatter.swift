//
//  DateFormatter.swift
//  ChatCollection
//
//  Created by Zeto on 2023/01/18.
//

import Foundation

struct MessageDateFormatter {
    
    private let dateFormatter: DateFormatter = .init()
    
    init() {
        self.configureFormat()
    }
    
    func convertToString(from date: Date) -> String {
        
        return self.dateFormatter.string(from: date)
    }
}

private extension MessageDateFormatter {
    
    func configureFormat() {
        let format: String = "a hh:mm"
        
        self.dateFormatter.dateFormat = format
        self.dateFormatter.locale = Locale(identifier: "ko")
    }
}
