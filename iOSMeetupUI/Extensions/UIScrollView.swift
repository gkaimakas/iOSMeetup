//
//  UIScrollView.swift
//  iOSMeetupUI
//
//  Created by George Kaimakas on 7/11/19.
//  Copyright © 2019 George Kaimakas. All rights reserved.
//

import ReactiveCocoa
import ReactiveSwift
import UIKit

public extension Reactive where Base: UIScrollView {
    func isNearBottom(threshold: CGFloat = 50) -> Signal<Bool, Never> {
        func isNearBottomEdge(scrollView: UIScrollView, edgeOffset: CGFloat = threshold) -> Bool {
            return scrollView.contentOffset.y + scrollView.frame.size.height + edgeOffset > scrollView.contentSize.height
        }
        
        return signal(for: \.contentOffset)
            .map { point -> Bool in
                isNearBottomEdge(scrollView: self.base, edgeOffset: threshold)
        }
        .skipRepeats()
    }
}
