//
//  MessageCollectionViewLayout.swift
//  ChatCollection
//
//  Created by Zeto on 2023/01/16.
//

import UIKit

/// 메시지 컬렉션뷰 레이아웃
final class MessageCollectionViewLayout: UICollectionViewLayout {
    
    // 동적 높이를 알기 위한 delegate 참조
    weak var delegate: MessageCollectionViewLayoutDelegate?
    
    // 보여질 컬럼 갯수와 item 간의 간격
    // 현재는 컬럼이 하나만 있으면 되기 때문에 따로 프로퍼티 X
    private let cellPadding: CGFloat = 4
    
    // 각 item들의 레이아웃 정보를 저장할 cache
    private var cachedAttributes: [UICollectionViewLayoutAttributes] = []
    
    // CollectionView 내부의 ScrollView의 height 값 (item이 보여지는 양에 따라 증가)
    private var contentHeight: CGFloat = 0.0
    
    // CollectionView 내부의 ScrollView의 width 값
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0.0
        }
        
        // VC에서 inset 지정 가능 (CollectionView의 내부 padding)
        let insets = collectionView.contentInset
        
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    // scroll된 content의 전체 크기
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    // 가장 먼저 호출되는 함수로서 x, y 위치를 지정하고 width, height로 화면에 그림 (autolayout 개념과 유사)
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        // 중복 방지를 위해 cache 값을 비워줌
        self.cachedAttributes.removeAll()
        
        // xOffset 계산
        // 컬럼이 여러개라면 yOffset처럼 계산 로직이 필요
        let columWidth: CGFloat = contentWidth
        let xOffset: CGFloat = 0
        
        // yOffset 계산
        var yOffset: CGFloat = 0
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            
            // 동적 높이 계산
            let cellHeight = delegate?.collectionView(collectionView, heightForCellAtIndexPath: indexPath) ?? 0
            let height = cellPadding * 2 + cellHeight
            
            // item의 frame
            // insetBy만큼 터치 인식 영역이 증가하거나 감소
            let frame = CGRect(x: xOffset, y: yOffset, width: columWidth, height: height)
            // dx, dy가 양수이면 bounds의 크기 감소, 음수이면 bounds의 크기 증가
            let insetFrame = frame.insetBy(dx: 0, dy: cellPadding)
            
            // cache 저장
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cachedAttributes.append(attributes)
            
            // 새로 계산된 항목의 프레임을 설명하도록 확장
            contentHeight = max(contentHeight, frame.maxY)
            yOffset = yOffset + height
        }
    }
    
    // 모든 아이템들에 대한 레이아웃 attributes 리턴 (보여지는 부분 / rect와 겹치는 부분)
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        // rect와 겹치는 부분 리턴
        return cachedAttributes.filter { rect.intersects( $0.frame) }
    }
    
    // 아이템에 대한 layout 속성을 리턴
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedAttributes[indexPath.item]
    }
}

