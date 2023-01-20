//
//  ReceiveCell.swift
//  ChatCollection
//
//  Created by Zeto on 2023/01/19.
//

import UIKit
import SnapKit
import Then

final class ReceiveCell: MessageCell {
    
    static let identifier: String = .init(describing: ReceiveCell.self)
    
    private let messageLabel: PaddingLabel = .init().then {
        $0.numberOfLines = 0
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 14.5)
        $0.backgroundColor = .white
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
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

private extension ReceiveCell {
    
    func configureLayouts() {
        self.addSubviews(messageLabel, dateLabel)
        
        messageLabel.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(56)
            make.trailing.lessThanOrEqualToSuperview()
        }
        
        dateLabel.snp.remakeConstraints { make in
            make.leading.equalTo(messageLabel.snp.trailing).offset(4)
            make.trailing.lessThanOrEqualToSuperview().inset(24)
            make.bottom.equalTo(messageLabel)
        }
    }
}

