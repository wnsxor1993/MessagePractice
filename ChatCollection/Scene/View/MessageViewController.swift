//
//  ViewController.swift
//  ChatCollection
//
//  Created by Zeto on 2023/01/16.
//

import UIKit
import SnapKit
import Then

class MessageViewController: UIViewController {

    private lazy var messageCollectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: .init()).then {
        guard let compositionalLayout = MessageCompositionalLayout().compositionalLayoutSection else {
            return }
        
        $0.collectionViewLayout = compositionalLayout
        $0.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        $0.backgroundColor = .clear
        $0.register(MessageCell.self, forCellWithReuseIdentifier: MessageCell.identifier)
        $0.delegate = self
        $0.dataSource = self
    }
    
    private let messages: [ChatDTO] = [ChatDTO(chatType: .receive, message: "이것은 테스트 메세지입니다. 우헤헤헤헤헤헤헿ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ"), ChatDTO(chatType: .receive, message: "얘는\n어떻게\n나오려나"), ChatDTO(chatType: .send, message: "마이크 테스트"), ChatDTO(chatType: .send, message: "아직 잘 모르겠음"), ChatDTO(chatType: .receive, message: "모든 것이 너의 부족함 탓이거늘ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ"), ChatDTO(chatType: .receive, message: "개빡\n딥빡\n시부럴탱탱")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 216/255, green: 238/255, blue: 192/255, alpha: 1)
        self.configureLayouts()
    }
}

extension MessageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageCell.identifier, for: indexPath) as? MessageCell else { return .init() }
        
        cell.setCell(with: messages[indexPath.row].message, type: messages[indexPath.row].chatType)
        cell.layoutIfNeeded()
        
        return cell
    }
}

private extension MessageViewController {
    
    func configureLayouts() {
        self.view.addSubview(messageCollectionView)
        
        messageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.leading.trailing.equalToSuperview()
        }
    }
}
