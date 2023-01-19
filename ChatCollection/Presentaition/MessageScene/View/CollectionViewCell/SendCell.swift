//
//  MessageCell.swift
//  ChatCollection
//
//  Created by Zeto on 2023/01/16.
//

import UIKit
import SnapKit
import Then

final class SendCell: MessageCell {
    
    static let identifier: String = .init(describing: SendCell.self)
    
    private let messageLabel: PaddingLabel = .init().then {
        $0.numberOfLines = 0
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 14.5)
        $0.backgroundColor = UIColor(red: 250/255, green: 230/255, blue: 76/255, alpha: 1)
        $0.lineBreakStrategy = .pushOut
        $0.layer.cornerRadius = 14
        $0.clipsToBounds = true
        
        $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
        $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    private let dateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 10, weight: .regular)
        $0.textColor = .secondaryLabel
        $0.numberOfLines = 1
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureLayouts()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Does not use this initializer")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        messageLabel.text = nil
        dateLabel.text = nil
        
        self.messageLabel.layoutIfNeeded()
    }
    
    override func setCell(with message: String, dateString: String) {
        self.messageLabel.text = message
        self.dateLabel.text = dateString
    }
}

private extension SendCell {
    
    func configureLayouts() {
        self.addSubviews(messageLabel, dateLabel)
        
        messageLabel.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
            make.leading.greaterThanOrEqualToSuperview()
        }
        
        dateLabel.snp.remakeConstraints { make in
            make.trailing.equalTo(messageLabel.snp.leading).offset(-4)
            make.leading.greaterThanOrEqualToSuperview().inset(56)
            make.bottom.equalTo(messageLabel)
        }
    }
}
