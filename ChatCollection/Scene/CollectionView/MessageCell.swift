//
//  MessageCell.swift
//  ChatCollection
//
//  Created by Zeto on 2023/01/16.
//

import UIKit
import SnapKit
import Then

final class MessageCell: UICollectionViewCell {
    
    static let identifier: String = .init(describing: MessageCell.self)
    
    private let messageLabel: PaddingLabel = .init().then {
        $0.numberOfLines = 0
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 14.5)
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
    
    private var chatType: ChatType = .none
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubviews(messageLabel, dateLabel)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Does not use this initializer")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        messageLabel.text = ""
        dateLabel.text = ""
        chatType = .none
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        self.configureLayouts()
//        self.configureProperties()
//    }
    
    func setCell(with message: String, type: ChatType) {
        self.messageLabel.text = message
        self.chatType = type
        self.dateLabel.text = "오전 03:20"
        
        self.configureLayouts()
        self.configureProperties()
    }
}

private extension MessageCell {
    
    func configureLayouts() {
        switch chatType {
        case .none:
            break
        
        case .send:
            messageLabel.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.trailing.equalToSuperview().inset(20)
                make.leading.greaterThanOrEqualToSuperview()
            }
            
            dateLabel.snp.makeConstraints { make in
                make.trailing.equalTo(messageLabel.snp.leading).offset(-4)
                make.leading.greaterThanOrEqualToSuperview().inset(56)
                make.bottom.equalTo(messageLabel)
            }
            
        case .receive:
            messageLabel.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.leading.equalToSuperview().inset(56)
                make.trailing.lessThanOrEqualToSuperview()
            }
            
            dateLabel.snp.makeConstraints { make in
                make.leading.equalTo(messageLabel.snp.trailing).offset(4)
                make.trailing.lessThanOrEqualToSuperview().inset(24)
                make.bottom.equalTo(messageLabel)
            }
        }
    }
    
    func configureProperties() {
        switch chatType {
        case .none:
            break
        
        case .send:
            messageLabel.backgroundColor = UIColor(red: 250/255, green: 230/255, blue: 76/255, alpha: 1)
            
        case .receive:
            messageLabel.backgroundColor = .white
        }
    }
}
