//
//  UICollectionView+Extension.swift
import UIKit
import Foundation


typealias ButtonClick = (_ button :UIButton) -> Void


extension String {
    func nsRange(from range: Range<String.Index>?) -> NSRange? {
        if let range = range{
            let utf16view = self.utf16
            if let from = range.lowerBound.samePosition(in: utf16view), let to = range.upperBound.samePosition(in: utf16view) {
                return NSMakeRange(utf16view.distance(from: utf16view.startIndex, to: from), utf16view.distance(from: from, to: to))
            }
        }
        return nil
    }
}
