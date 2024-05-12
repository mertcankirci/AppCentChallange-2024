//
//  UIHelper.swift
//  AppCentChallange-2024
//
//  Created by Mertcan Kırcı on 8.05.2024.
//

import UIKit

enum EmptyStateScreen {
    case home, saved
}

struct UIHelper {
    static func createNewsFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 32
        let availableWidth = width - (padding * 2) // Since we're creating a one column layout availableWidth equals itemWidth
        let minimumSpacing: CGFloat = 16
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: availableWidth, height: availableWidth * 0.75)
        flowLayout.minimumLineSpacing = minimumSpacing
        
        return flowLayout
    }

    static func calculateCustomItemWidthForThree(in view: UIView, viewPadding viewPad: CGFloat, itemPadding itemPad: CGFloat) -> CGFloat {
        let availableWidth = view.bounds.width - ( 2 * viewPad)
        let itemWidth = (availableWidth - ( 2 * itemPad )) / 3
        
        return itemWidth
    }
    
    static func emptyStateViewHelper(in vc: UIViewController, articles: [Article], screen: EmptyStateScreen) {
        var messageString = ""
        
        switch screen {
        case .home:
            messageString = "Please search for a keyword to list the results ! 🌍 "
        case .saved:
            messageString = "You didn't save any news. Lets go and save some ! 😇"
        }
        
        if articles.isEmpty {
            DispatchQueue.main.async {
                vc.presentEmptyStateLottieAnimation(with: messageString, in: vc.view, screenType: screen)
            }
        } else {
            DispatchQueue.main.async {
                vc.dismissEmptyStateLottieAnimation()
            }
        }
    }
    
    static func formatDate(for date: String) -> String {
        guard let formattedDate = date.convertToDate() else { return ""}
        return formattedDate.convertToMonthYearDayFormat()
    }
    
    
    //MARK: Remove the '[+???] characters' part from the article content if it exists. For UI purposes.
    static func removeTrailingPlusFromContent(from text: String) -> String {
        do {
            // '//[+'means starts with this pattern and '.*$' till at the end of the string.
            let regex = try NSRegularExpression(pattern: "\\[+.*$", options: [])
            let range = NSRange(location: 0, length: text.utf16.count)
            return regex.stringByReplacingMatches(in: text, options: [], range: range, withTemplate: "For more view on website.")
        } catch {
            return text
        }
    }
}
