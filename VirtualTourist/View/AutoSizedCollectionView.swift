//
//  AutoSizedCollectionView.swift
//  VirtualTourist
//
//  Created by Ricardo Bravo on 5/07/21.
//

import Foundation
import UIKit

class AutoSizedCollectionView: UICollectionView {

    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
