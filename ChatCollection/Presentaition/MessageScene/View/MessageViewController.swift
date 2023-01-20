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

final class MessageViewController: UIViewController {

    private lazy var messageCollectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: .init()).then {
        guard let compositionalLayout = MessageCompositionalLayout().compositionalLayoutSection else {
            return }
        
        $0.collectionViewLayout = compositionalLayout
        $0.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        $0.backgroundColor = .clear
        $0.register(SendCell.self, forCellWithReuseIdentifier: SendCell.identifier)
        $0.register(ReceiveCell.self, forCellWithReuseIdentifier: ReceiveCell.identifier)
    }
    
    private let messageButton: UIButton = .init().then {
        $0.setTitle("보내기", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .gray
    }
    
    private let sectionModelsRelay: PublishRelay<[DiffableSection]> = .init()
    private let viewModel: MessageViewModel = .init()
    
    private lazy var messageDiffableDataSource: MessageDiffableDataSource = .init(self.messageCollectionView)
    private let dataSourceManager: DiffableDataSourceManager = .init()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 216/255, green: 238/255, blue: 192/255, alpha: 1)
        self.configureLayouts()
        self.bindInnerAction()
        self.bindWithViewModel()
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
    }
    
    func bindWithViewModel() {
        let textButtonString = self.messageButton.rx.tap.map {
            let texts: [String] = ["이건 테스트", "바바바\n마마마\n요호호", "ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ", "요건 몰랐지", "abcdefghijklmnopqrstuvwxyz"]
            return texts.randomElement() ?? "Nil"
        }
            
        let input: MessageViewModel.Input = .init(viewWillAppear: self.rx.viewWillAppear.asDriver(onErrorJustReturn: false),
                                                  textButton: textButtonString.asDriver(onErrorJustReturn: ""))
        let ouput: MessageViewModel.Output = self.viewModel.transfer(with: input)
        
        ouput.dataSourceRelay
            .subscribe { [weak self] result in
                guard let self, let datas = result.element else { return }
                
                if self.messageDiffableDataSource.hasSnapshot {
                    self.messageDiffableDataSource.addItems(with: datas)
                    
                } else {
                    self.messageDiffableDataSource.fetchBaseDatas(with: datas)
                }
            }
            .disposed(by: disposeBag)
    }
}
