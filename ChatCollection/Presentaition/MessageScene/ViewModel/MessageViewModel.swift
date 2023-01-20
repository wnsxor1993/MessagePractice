//
//  MessageViewModel.swift
//  ChatCollection
//
//  Created by Zeto on 2023/01/19.
//

import RxSwift
import RxCocoa

final class MessageViewModel {
    
    struct Input {
        let viewWillAppear: Driver<Bool>
        let textButton: Driver<String>
    }
    
    struct Output {
        let dataSourceRelay: PublishRelay<[DiffableSection: [ChatDTO]]> = .init()
    }
    
    private let dataSourceManager: DiffableDataSourceManager = .init()
    private let output: Output = .init()
    private let disposeBag: DisposeBag = .init()
    
    func transfer(with input: Input) -> Output {
        input.viewWillAppear
            .drive { [weak self] isAppear in
                guard let self, isAppear else { return }
                
                self.dataSourceManager.fetchPreviousMessages()
                    .subscribe { [weak self] result in
                        guard let self, let sectionDic = result.element else { return }
                        
                        self.output.dataSourceRelay.accept(sectionDic)
                    }
                    .disposed(by: self.disposeBag)
            }
            .disposed(by: disposeBag)
        
        input.textButton
            .drive { [weak self] inputText in
                guard let self, inputText != "" else { return }
                
                self.dataSourceManager.sendMessage(text: inputText)
                    .subscribe { [weak self] result in
                        guard let self, let sectionDic = result.element else { return }
                        
                        self.output.dataSourceRelay.accept(sectionDic)
                    }
                    .disposed(by: self.disposeBag)
            }
            .disposed(by: disposeBag)
        
        return output
    }
}
