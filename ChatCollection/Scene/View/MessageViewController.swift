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
    
    private var messageDataSource: RxCollectionViewSectionedAnimatedDataSource<SectionModel>?
    private let sectionModelsRelay: PublishRelay<[SectionModel]> = .init()
    
    let dataManager: RxDataSourceManager = .shared
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 216/255, green: 238/255, blue: 192/255, alpha: 1)
        self.configureLayouts()
        self.bindInnerAction()
        self.bindDataSource()
    }
    
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//
//        guard !(self.messageCollectionView.visibleCells.isEmpty) else { return }
//
//        self.messageCollectionView.collectionViewLayout.invalidateLayout()
//    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.messageCollectionView.subviews.forEach {
            print("width: \($0.frame.width), height: \($0.frame.height)")
        }
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
    
    func bindInnerAction() {
        self.messageCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        self.messageDataSource = RxCollectionViewSectionedAnimatedDataSource(configureCell: { dataSource, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageCell.identifier, for: indexPath) as? MessageCell else { return .init() }
            
            let formatter: MessageDateFormatter = .init()
            let dateString: String = formatter.convertToString(from: item.date)
            
            cell.setCell(with: item.message, type: item.chatType, dateString: dateString)
            
            DispatchQueue.main.async {
                self.messageCollectionView.scrollToBottom(animated: false)
            }
            
            return cell
        })
        
        self.messageButton.rx
            .tap
            .asDriver()
            .drive { [weak self] _ in
                guard let self else { return }
                
                defer {
                    self.sectionModelsRelay.accept(self.dataManager.fetchSectionModels())
                }
                
                let texts: [String] = ["이건 테스트", "바바바\n마마마\n요호호", "ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ"]
                
                self.dataManager.sendMessage(text: texts.randomElement() ?? "Nil")
            }
            .disposed(by: disposeBag)
    }
    
    func bindDataSource() {
        guard let messageDataSource else { return }
        
        self.sectionModelsRelay
            .bind(to: messageCollectionView.rx.items(dataSource: messageDataSource))
            .disposed(by: disposeBag)
    }
}
