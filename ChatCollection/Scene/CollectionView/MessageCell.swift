//
//  MessageCell.swift
//  ChatCollection
//
//  Created by Zeto on 2023/01/19.
//

import UIKit
import SnapKit
import Then

class MessageCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Does not use this initializer")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setCell(with message: String, dateString: String) { }
}
