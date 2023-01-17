//
//  PaddingLabel.swift
//  ChatCollection
//
//  Created by Zeto on 2023/01/16.
//

import UIKit

class PaddingLabel: UILabel {
    
    private var topInset: CGFloat
    private var bottomInset: CGFloat
    private var leftInset: CGFloat
    private var rightInset: CGFloat
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        
        return CGSize(width: size.width + leftInset + rightInset, height: size.height + topInset + bottomInset)
    }
    
    override var bounds: CGRect {
        didSet {
            preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
        }
    }
    
    init(topInset: CGFloat = 8, bottomInset: CGFloat = 8, leftInset: CGFloat = 10, rightInset: CGFloat = 10) {
        self.topInset = topInset
        self.bottomInset = bottomInset
        self.leftInset = leftInset
        self.rightInset = rightInset
        
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Does not use this initializer")
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        
        super.drawText(in: rect.inset(by: insets))
    }
}
