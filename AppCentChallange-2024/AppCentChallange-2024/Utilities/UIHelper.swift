//
//  UIHelper.swift
//  AppCentChallange-2024
//
//  Created by Mertcan Kırcı on 8.05.2024.
//

import UIKit

struct UIHelper {
    static func createNewsFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 32
        let availableWidth = width - (padding * 2) // Since we're creating a one column layout availableWidth equals itemWidth
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: availableWidth, height: availableWidth * 0.75)
        flowLayout.minimumLineSpacing = CGFloat(16)
        
        return flowLayout
    }

    static func calculateCustomItemWidthForThree(in view: UIView, viewPadding viewPad: CGFloat, itemPadding itemPad: CGFloat) -> CGFloat {
        let availableWidth = view.bounds.width - ( 2 * viewPad)
        let itemWidth = (availableWidth - ( 2 * itemPad )) / 3
        
        return itemWidth
    }
}
