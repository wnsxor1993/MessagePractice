//
//  ViewController.swift
//  ChatCollection
//
//  Created by Zeto on 2023/01/16.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import RxDataSources

class MessageViewController: UIViewController {

    private lazy var messageCollectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: .init()).then {
        guard let compositionalLayout = MessageCompositionalLayout().compositionalLayoutSection else {
            return }
        
        $0.collectionViewLayout = compositionalLayout
        $0.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        $0.backgroundColor = .clear
        $0.register(MessageCell.self, forCellWithReuseIdentifier: MessageCell.identifier)
    }
    
    private let messageButton: UIButton = .init().then {
        $0.setTitle("보내기", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .gray
    }
    
    private let sectionModelsRelay: PublishRelay<[DiffableSection]> = .init()
    
    private var messageDiffableDataSource: UICollectionViewDiffableDataSource<DiffableSection, ChatDTO>?
    private let dataSourceManager: DiffableDataSourceManager = .init()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 216/255, green: 238/255, blue: 192/255, alpha: 1)
        self.configureLayouts()
        self.bindInnerAction()
        self.configureDataSource()
    }
}

extension MessageViewController: UICollectionViewDelegate {
    
}

private extension MessageViewController {
    
    func configureLayouts() {
        self.view.addSubviews(messageCollectionView, messageButton)
        
        messageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.leading.trailing.equalToSuperview()
        }
        
        messageButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(15)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(60)
        }
    }
    
    func configureDataSource() {
        self.messageDiffableDataSource = UICollectionViewDiffableDataSource(collectionView: self.messageCollectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageCell.identifier, for: indexPath) as? MessageCell else { return .init() }
            
            let formatter: MessageDateFormatter = .init()
            let dateString: String = formatter.convertToString(from: item.date)
            
            cell.setCell(with: item.message, type: item.chatType, dateString: dateString)
            
            DispatchQueue.main.async {
                self.messageCollectionView.scrollToBottom(animated: false)
            }
            
            return cell
        }
        
        guard let messageDiffableDataSource else { return }
        
        self.messageCollectionView.dataSource = messageDiffableDataSource
        self.dataSourceManager.setDataSource(messageDiffableDataSource)
    }
    
    func bindInnerAction() {
        self.messageCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        self.messageButton.rx
            .tap
            .asDriver()
            .drive { [weak self] _ in
                guard let self else { return }
                
                let texts: [String] = ["이건 테스트", "바바바\n마마마\n요호호", "ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ", "요건 몰랐지", "abcdefghijklmnopqrstuvwxyz"]
                let sendType: [ChatType] = [.send, .receive]
                
                self.dataSourceManager.sendMessage(text: texts.randomElement() ?? "Nil", type: sendType.randomElement() ?? .none)
            }
            .disposed(by: disposeBag)
    }
}
